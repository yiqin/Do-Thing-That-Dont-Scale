//
//  RecentsTableViewCell.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "PFTableViewCell.h"
#import <Parse/Parse.h>
#import "YQLabel.h"

@interface RecentsTableViewCell : PFTableViewCell

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) YQLabel *taglineLable;

@end
