//
//  ProductUpvoteCollectionViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProductUpvoteCollectionViewCell.h"

@implementation ProductUpvoteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.profileImageView.layer.cornerRadius = 40*0.5;
    self.profileImageView.clipsToBounds = YES;
}

@end
