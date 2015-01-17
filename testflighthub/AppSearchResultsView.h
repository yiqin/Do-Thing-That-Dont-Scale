//
//  AppSearchResultsView.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppSearchResultsDelegate;
@class App;

@interface AppSearchResultsView : UIView <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSString *enteredAppName;



@property (strong, nonatomic) NSMutableArray *searchResults;

@property (strong, nonatomic) UITableViewController *searchResultsTableViewController;
@property (strong, nonatomic) UITableView *searchResultsTableView;

@property (nonatomic) id<AppSearchResultsDelegate> delegate;


- (void)updateEnteredAppName:(NSString *)enteredAppName;

@end


@protocol AppSearchResultsDelegate

- (void) selectedAppFromSearch: (App*) app;
- (void) changeSearchResultsViewSizeWithNewHeight: (CGFloat) newHeight;
- (void) hideKeyboard;
// - (void) showKeyboard;


@end