//
//  RecentsTableViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "RecentsTableViewCell.h"

@implementation RecentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17.0];
        // self.nameLabel.backgroundColor = [UIColor redColor];
        
        self.taglineLable = [[YQLabel alloc] init];
        // self.taglineLable.backgroundColor = [UIColor yellowColor];
        self.taglineLable.font = [UIFont fontWithName:@"Lato-Regular" size:14.0];
        
        [self addSubview:self.nameLabel];
        [self addSubview:self.taglineLable];
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(10.0f, 10.0f, CGRectGetWidth(self.frame)-20, 30);
    [self.taglineLable setFrame:CGRectMake(10.0f, 50.0f, CGRectGetWidth(self.frame)-20, 50) font:self.taglineLable.font text:self.taglineLable.text];
}


@end
