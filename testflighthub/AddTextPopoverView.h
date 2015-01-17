//
//  AddTextPopoverView.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTextPopoverDelegate;

@interface AddTextPopoverView : UIView<UITextViewDelegate>

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title placeholder:(NSString*)placeholder;
@property(nonatomic, strong) id<AddTextPopoverDelegate> delegate;

@property(nonatomic, strong) NSString *rightButtonTitle;

@end


@protocol AddTextPopoverDelegate

-(void)cancelTextInput;
-(void)finishTextInput:(NSString *)text;

@end
