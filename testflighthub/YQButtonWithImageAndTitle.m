//
//  YQButtonWithImageAndTitle.m
//  testflighthub
//
//  Created by Yi Qin on 12/24/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

#import "YQButtonWithImageAndTitle.h"

@implementation YQButtonWithImageAndTitle

-(instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage*)normalImage highlightedImage:(UIImage*)hightlightedImage
{
    self = [self initWithFrame:frame];
    if (self) {
        
        [self setFrame:frame]; // SET the values for your wishes
        // [self setCenter:CGPointMake(128.f, 128.f)]; // SET the values for your wishes
        [self setClipsToBounds:false];
        [self setBackgroundImage:normalImage forState:UIControlStateNormal]; // SET the image name for your wishes
        [self setBackgroundImage:hightlightedImage forState:UIControlStateHighlighted];
        
        [self setTitle:@"Button" forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:24.f]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; // SET the colour for your wishes
        [self setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted]; // SET the colour for your wishes
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.f, 0.f, -110.f, 0.f)]; // SET the values for your wishes
        // [self addTarget:self action:@selector(buttonTouchedUpInside:) forControlEvents:UIControlEventTouchUpInside]; // you can ADD the action to the button as well like
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
