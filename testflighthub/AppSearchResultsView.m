//
//  AppSearchResultsView.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "AppSearchResultsView.h"
#import "AppSearchEngine.h"
#import <testflighthub-Swift.h>
#import "AppSearchResultTableViewCell.h"
#import <SVProgressHUD.h>

@interface AppSearchResultsView()

@property(nonatomic) BOOL isResults;

@end

@implementation AppSearchResultsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.searchResults = [[NSMutableArray alloc] init];
        self.enteredAppName = @"";
        self.isResults = YES;
        
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    // TableView first
    self.searchResultsTableView = [[UITableView alloc] init];
    // self.searchResultsTableView.separatorColor = [UIColor clearColor];
    self.searchResultsTableView.backgroundColor = [UIColor clearColor];
    self.searchResultsTableView.delegate = self;
    self.searchResultsTableView.dataSource = self;
    
    self.searchResultsTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.searchResultsTableViewController setTableView:self.searchResultsTableView];
    
    self.searchResultsTableViewController.view.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    [self addSubview:self.searchResultsTableViewController.view];
}

- (void)setEnteredAppName:(NSString *)enteredAppName
{
    _enteredAppName = enteredAppName;
}

- (void)setSearchResultsResults:(NSMutableArray *)searchResultsResults
{
    _searchResults = searchResultsResults;
}

- (void)updateEnteredAppName:(NSString *)enteredAppName
{
    if (enteredAppName.length > 0) {
        [self.searchResults removeAllObjects];
        AppSearchEngine *appSearchEngine = [[AppSearchEngine alloc] init];
        
        [SVProgressHUD show];
        
        [appSearchEngine searchWithTitle:enteredAppName success:^(NSArray *apps) {
            [self.searchResults addObjectsFromArray:apps];
            NSLog(@"%lu", (unsigned long)self.searchResults.count);
            [TestMixpanel getSearchResult:self.searchResults.count];
            
            if (apps.count == 0) {
                self.isResults = NO;
            }
            else {
                self.isResults = YES;
            }
            
            [SVProgressHUD dismiss];
            
            [self.searchResultsTableViewController.tableView reloadData];
            [self.delegate changeSearchResultsViewSizeWithNewHeight:[self getViewHeight:self.searchResults]];
            
        } failure:^(NSError *error) {
            
        }];
    }
}

- (CGFloat)getViewHeight:(NSMutableArray *)searchResultsResults
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    // CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGFloat viewHeight = 0;
    if (self.isResults) {
        if (searchResultsResults.count*[AppSearchResultTableViewCell cellHeight] > screenHeight-44) {
            viewHeight = screenHeight-44;
        }
        else {
            viewHeight = [searchResultsResults count]*[AppSearchResultTableViewCell cellHeight];
        }
    }
    else {
        viewHeight = [AppSearchResultTableViewCell cellHeight];
    }
    
    self.searchResultsTableViewController.view.frame = CGRectMake(0, 0, self.frame.size.width, viewHeight);
    return viewHeight;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"self.searchResultsResults.count %i", self.searchResults.count);
    if (self.isResults) {
        return self.searchResults.count;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AppSearchResultTableViewCell cellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"Will begin dragging");
    
    if (self.isResults) {
        [self.delegate hideKeyboard];
    }
    else {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"Did Scroll");
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isResults) {
        static NSString *cellIdentifier = @"SearchResults";
        
        AppSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[AppSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        if (indexPath.row < self.searchResults.count) {
            App *app = [self.searchResults objectAtIndex:indexPath.row];
            cell.app = app;
        }
        
        return cell;
    }
    else {
        static NSString *noResultsCellIdentifier = @"NoResults";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noResultsCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noResultsCellIdentifier];
        }
        cell.textLabel.text = @"No found. Please re-enter the name.";
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isResults) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        App *app = [self.searchResults objectAtIndex:indexPath.row];
        [self.delegate selectedAppFromSearch:app];
    }
    else {
        
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
