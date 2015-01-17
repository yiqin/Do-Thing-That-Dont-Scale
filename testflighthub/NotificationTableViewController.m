//
//  NotificationTableViewController.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "NotificationTableViewController.h"
#import "NotificationTableViewCell.h"
#import "NSDate+DateTools.h"
#import <Parse/Parse.h>
#import <testflighthub-Swift.h>

@interface NotificationTableViewController ()
@property (nonatomic, assign) BOOL shouldReloadOnAppear;

@end

@implementation NotificationTableViewController

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Notification";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        // self.objectsPerPage = 10;
        
        // Improve scrolling performance by reusing UITableView section headers
        // The Loading text clashes with the dark Anypic design
        self.loadingViewEnabled = NO;
        
        self.shouldReloadOnAppear = NO;
        
        // Notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateNew) name:@"showCreateNewFromNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    // self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [super viewDidLoad];
    [TestMixpanel enteredNotification];
    // Do any additional setup after loading the view.
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // WTF: this is the most ridiculous thing I meet in iOS development.
    [self.tabBarController.tabBar setFrame:CGRectZero];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.shouldReloadOnAppear) {
        self.shouldReloadOnAppear = NO;
        [self loadObjects];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showCreateNew {
    // [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    CreateNewViewController *createNewVC = [[CreateNewViewController alloc] init];
    createNewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:createNewVC animated:YES completion:^{
        
    }];
    
    // [self performSegueWithIdentifier:@"PushSegure3" sender:self];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query setLimit:10];
    [query orderByDescending:@"createdAt"];
    
    // A pull-to-refresh should always trigger a network request.
    // [query setCachePolicy:kPFCachePolicyNetworkOnly];
    
    return query;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.objects.count == 0) {
        return 0;
    }
    else {
        return self.objects.count+1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [NotificationTableViewCell cellHeight];
    }
    else {
        return [LoadMoreDataTableViewCell cellHeight];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.objects.count) {
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        
        static NSString *CellIdentifier = @"NotificationCell";
        
        NotificationTableViewCell *cell = (NotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        /*
        if (cell == nil) {
            cell = [[NotificationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        */
        
        if (object) {
            // cell.textLabel.text = [object objectForKey:@"title"];
            cell.titleLabel.text = [object objectForKey:@"title"];
            cell.messageLabel.text = [object objectForKey:@"message"];
            cell.timeLabel.text = object.createdAt.timeAgoSinceNow;
        }
        
        return cell;
    }
    else {
        NSString *CellIdentifier = @"LoadMoreDataCell";
        
        LoadMoreDataTableViewCell *cell = (LoadMoreDataTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[LoadMoreDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*
     if (![self objectAtIndexPath:indexPath]) {
     // Load More Cell
     [self loadNextPage];
     }
     */
    
    // NSString *type = [[self.objects objectAtIndex:indexPath.row] objectForKey:@"type"];
    
    
}

@end
