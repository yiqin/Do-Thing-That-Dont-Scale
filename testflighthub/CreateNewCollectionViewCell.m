//
//  CreateNewCollectionViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "CreateNewCollectionViewCell.h"

@implementation CreateNewCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.typeLabel];
    
    // self.finishImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recent_selected"]];
    
    NSLog(@"awake from nib");
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"%f ++++ %f", self.frame.size.width, self.frame.size.height);
    
    self.typeLabel.frame = CGRectMake(0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame), 30);
    // self.finishImageView.frame = CGRectMake(CGRectGetWidth(self.frame)-45, CGRectGetHeight(self.frame)-45, 40, 40);
}

- (void)addFinishIndicator
{
    // [self addSubview:self.finishImageView];
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:self.typeLabel.text];
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0,[attString length])];
    self.typeLabel.attributedText = attString;
}

@end
