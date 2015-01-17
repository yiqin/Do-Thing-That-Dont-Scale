//
//  NotificationTableViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "NotificationTableViewCell.h"
#import "YQLabel.h"

@implementation NotificationTableViewCell

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
        
        // No select now.
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
        self.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
        [self addSubview:self.titleLabel];
        
        
        self.messageLabel = [[YQLabel alloc] init];
        self.messageLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.messageLabel.numberOfLines = 2;
        [self addSubview:self.messageLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.timeLabel];
        
        self.type = @"undefine";
    }
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat xPadding = 16.0;
    CGFloat yPadding = 10.0;
    
    // [self.messageLabel setFrame:(CGRectMake(xPadding, yPadding, CGRectGetWidth(self.frame)-2*xPadding, CGRectGetHeight(self.frame)) font:self.messageLabel.font text:self.messageLabel.text];
    
    [self.titleLabel setFrame:CGRectMake(xPadding, yPadding, CGRectGetWidth(self.frame)-2*xPadding, 30)];
    
    [self.messageLabel setFrame:CGRectMake(xPadding, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame)-2*xPadding, CGRectGetHeight(self.frame)) font:self.messageLabel.font text:self.messageLabel.text];
    
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-90, yPadding, 80, 30);
                                 
}

+ (CGFloat)cellHeight {
    return 100;
}


@end
