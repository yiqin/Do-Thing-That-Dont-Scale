//
//  YQButtonWithImageAndTitle.h
//  testflighthub
//
//  Created by Yi Qin on 12/24/14.
//  Copyright (c) 2014 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YQButtonWithImageAndTitle : UIButton

// http://stackoverflow.com/questions/11717219/uibutton-image-text-ios
-(instancetype)initWithFrame:(CGRect)frame normalImage:(UIImage*)normalImage highlightedImage:(UIImage*)hightlightedImage;

@end
