//
//  CreateNewCollectionViewCell.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNewCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) UILabel *typeLabel;

@property(nonatomic) BOOL isFinished;
// @property(nonatomic, strong) UIImageView *finishImageView;

- (void)addFinishIndicator;

@end
