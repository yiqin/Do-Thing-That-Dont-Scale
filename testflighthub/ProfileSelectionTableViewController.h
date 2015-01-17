//
//  ProfileSelectionTableViewController.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileSelectionTVCDelegate;

@interface ProfileSelectionTableViewController : UITableViewController

@property(nonatomic, strong) id<ProfileSelectionTVCDelegate> delegate;
+(NSInteger)numberOfRows;

@end


@protocol ProfileSelectionTVCDelegate

- (void)goToYourRecommendations;
- (void)goToYourLikes;

@end