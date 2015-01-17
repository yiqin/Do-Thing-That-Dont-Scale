//
//  TrendTableViewCell.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "PFTableViewCell.h"
#import <Parse/Parse.h>
#import "YQLabel.h"
#import "AYVibrantButton.h"

@protocol TrendingTableViewCellDelegate;
@class Product;


@interface TrendingTableViewCell : PFTableViewCell <UIAlertViewDelegate>

@property(nonatomic, strong) Product *product;
@property(nonatomic) BOOL alreadyLike;

@property(nonatomic, strong) NSNumber *allLikeCount;

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) YQLabel *taglineLabel;
@property(nonatomic, strong) YQLabel *descriptionLabel;
@property(nonatomic, strong) PFImageView *iconImageView;

@property(nonatomic, strong) AYVibrantButton *getButton;
@property(nonatomic, strong) UIButton *likeButton;

@property(nonatomic, strong) UILabel *likeCountLabel;

@property(nonatomic, strong) UILabel *timeLabel;

@property(nonatomic, strong) id<TrendingTableViewCellDelegate> delegate;

- (void)checkLikeOnParse:(Product *)product success:(void (^)(BOOL))success;

- (void) setContentValue:(Product*)product object:(PFObject*)object;

+ (CGFloat)cellHeight;

@end


@protocol TrendingTableViewCellDelegate
- (void)openWebsiteWithAddress:(NSURL*)url;

@end


