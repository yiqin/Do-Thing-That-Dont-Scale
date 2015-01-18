//
//  TrendTableViewController.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "TrendingTableViewController.h"
#import "ProductWebsiteViewController.h"
#import <testflighthub-Swift.h>
#import "NSDate+DateTools.h"
#import <SVProgressHUD.h>

@interface TrendingTableViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@property (nonatomic, strong) NSMutableArray *products;     // parse data to product
@property (nonatomic, strong) NSMutableArray *objects;      // original data from parse

@property (nonatomic) int currentPageIndex;
@property (nonatomic) int itemsPerPage;

@end

@implementation TrendingTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        
        self.currentPageIndex = 0;
        self.itemsPerPage = 20;
        
        // Notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateNew) name:@"showCreateNewFromTrending" object:nil];
                
        self.products = [[NSMutableArray alloc] init];
        self.objects = [[NSMutableArray alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"afterCreateAppAndReloadTable" object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    [TestMixpanel enteredTrending];
    
    // Do any additional setup after loading the view.
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // WTF: this is the most ridiculous thing I meet in iOS development. Tab bar fails to disappear.
    
    [SVProgressHUD show];
    
    [self.tabBarController.tabBar setFrame:CGRectZero];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.tableView addSubview:refreshControl];
    
    [self startToLoadFromParse];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    // NSNotificationCenter.defaultCenter().postNotificationName("showTabBarUIViewTwo", object: nil)
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBarUIViewTwo" object:nil];
    
    //
    // self.navigationController.delegate = self.circleNavigationControllerDelegate;
    
    self.navigationController.delegate = nil;
    
    // Remove layer mask...... (It doesn't work at all. Roll back to check this error.)
    self.navigationController.view.layer.mask = nil;
    self.view.layer.mask = nil;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCreateNew {
    [[DeviceManager sharedInstance] setTrendingScrollYPosition: self.tableView.contentOffset.y];
    
    // Regular animation
    CreateNewViewController *createNewVC = [[CreateNewViewController alloc] init];
    createNewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:createNewVC animated:YES completion:^{
        
    }];
    
    // [self performSegueWithIdentifier:@"PushSegure0" sender:self];
}

- (void)refresh:(id)sender
{
    [self startToLoadFromParse];
}

- (void)startToLoadFromParse {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query whereKey:@"isInReview" equalTo:[NSNumber numberWithBool:NO]];
    [query setLimit:self.itemsPerPage];
    self.currentPageIndex = 1;
    [query orderByDescending:@"scoreCurrent"];
    [query addDescendingOrder:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error..................");
        }
        else {
            if (objects.count == 0) {
                // [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startToLoadFromParse) userInfo:nil repeats:NO];
            }
            else {
                [SVProgressHUD dismiss];
                
                NSLog(@"success.................. %lu", (unsigned long)objects.count);
                self.products = [[NSMutableArray alloc] init];
                
                for (PFObject *object in objects){
                    Product *product = [[Product alloc] initWithParseObject:object];
                    [self.products addObject:product];
                }
                
                self.objects = [NSMutableArray arrayWithArray:objects];
                
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        }
    }];
}

- (void)startToLoadMoreFromParse
{
    [TestMixpanel loadMoreProducts];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Product"];
    [query whereKey:@"isInReview" equalTo:[NSNumber numberWithBool:NO]];
    [query setLimit:self.itemsPerPage];
    query.skip = self.itemsPerPage*self.currentPageIndex;
    self.currentPageIndex++;
    [query orderByDescending:@"scoreCurrent"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error..................");
        }
        else {
            if (objects.count == 0) {
                // [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(startToLoadFromParse) userInfo:nil repeats:NO];
            }
            else {
                NSLog(@"success.................. %lu", (unsigned long)objects.count);
                // self.products = [[NSMutableArray alloc] init];
                
                for (PFObject *object in objects){
                    Product *product = [[Product alloc] initWithParseObject:object];
                    [self.products addObject:product];
                }
                
                // self.objects = [NSMutableArray arrayWithArray:objects];
                [self.objects addObjectsFromArray:objects];
                
                [self.tableView reloadData];
                // [self.refreshControl endRefreshing];
            }
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.products.count == 0) {
        return 0;
    }
    else {
        return self.products.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.products.count) {
        return [TrendingTableViewCell cellHeight];
    }
    else {
        return [LoadMoreDataTableViewCell cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.products.count) {
        NSString *CellIdentifier = @"TrendingCell";
        
        TrendingTableViewCell *cell = (TrendingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // If we don't define anything on storyboard. we need this. Otherwise we don't need this one.
        /*
        if (cell == nil) {
            cell = [[TrendingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            NSLog(@"Creating TrendingTableViewCell");
        }
        */
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        if (object) {
            Product *product = [self.products objectAtIndex:indexPath.row];
            
            [cell setContentValue:product object:object];
            cell.delegate = self;
        }
        
        return cell;
    }
    else {
        NSString *CellIdentifier = @"LoadMoreDataCell";
        
        LoadMoreDataTableViewCell *cell = (LoadMoreDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[LoadMoreDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"No More";
        [self startToLoadMoreFromParse];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < self.products.count) {
        
        Product *product = [self.products objectAtIndex:indexPath.row];
        // ProductDetailTableViewController *productDetailTVC = [[ProductDetailTableViewController alloc] initWithProduct:product];
        
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] initWithNibName:nil bundle:nil product:product];
        
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }
    else {
        
    }
}

- (void)openWebsiteWithAddress:(NSURL *)url
{
    ProductWebsiteViewController *webViewController = [[ProductWebsiteViewController alloc] initWithURL:url];
    
    self.navigationController.delegate = nil;
    [self.navigationController pushViewController:webViewController animated:YES];
    
    [TestMixpanel getAppFromTrending];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
