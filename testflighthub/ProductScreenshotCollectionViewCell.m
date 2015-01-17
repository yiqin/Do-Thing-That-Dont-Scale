//
//  ProductScreenshotCollectionViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProductScreenshotCollectionViewCell.h"

@implementation ProductScreenshotCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.screenshotImageView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [self.screenshotImageView.layer setBorderWidth: 0.5];
}

@end
