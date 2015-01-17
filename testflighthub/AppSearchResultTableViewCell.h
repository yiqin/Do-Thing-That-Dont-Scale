//
//  AppSearchResultTableViewCell.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YQLabel.h"

@class App;

@interface AppSearchResultTableViewCell : UITableViewCell

@property(nonatomic, strong) App *app;

@property(nonatomic, strong) UILabel *appNameLabel;
@property(nonatomic, strong) UILabel *authorLabel;
@property(nonatomic, strong) UIImageView *iconImageView;

@property(nonatomic, strong) YQLabel *appDescriptionLabel;

+ (CGFloat)cellHeight;

@end
