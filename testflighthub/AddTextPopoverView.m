//
//  AddTextPopoverView.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "AddTextPopoverView.h"
#import <Colours.h>

#import "SDCAlertController.h"

@interface AddTextPopoverView()

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) NSString *textViewPlaceholder;

@property(nonatomic, strong) UIView *bottomView;
@property(nonatomic, strong) UIButton *leftBottomButton;
@property(nonatomic, strong) UIButton *rightBottomButton;

@end

@implementation AddTextPopoverView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title placeholder:(NSString*)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.title = title;
        self.textViewPlaceholder = placeholder;
        self.rightButtonTitle = @"Save";
        
        self.layer.cornerRadius = 10.0;
        self.clipsToBounds = YES;
        
        // self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 40)];
        titleLabel.text = title.uppercaseString;
        titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        // [self addSubview:titleLabel];
        
        
        
        self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-44, CGRectGetWidth(self.frame), 44)];
        // [self addSubview:self.bottomView];
        
        
        self.leftBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
        [self.leftBottomButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.leftBottomButton setTitleColor:[UIColor infoBlueColor]  forState:UIControlStateNormal];
        [self.leftBottomButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.leftBottomButton.titleLabel.font =  [UIFont fontWithName:@"Lato-Regular" size:17.5];
        [self.leftBottomButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.leftBottomButton];
        
        
        self.rightBottomButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, 0, 60, 44)];
        [self.rightBottomButton setTitle:@"Save" forState:UIControlStateNormal];
        [self.rightBottomButton setTitleColor:[UIColor infoBlueColor]  forState:UIControlStateNormal];
        [self.rightBottomButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.rightBottomButton.titleLabel.font =  [UIFont fontWithName:@"Lato-Bold" size:17.5];
        [self.rightBottomButton addTarget:self action:@selector(clickSave) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:self.rightBottomButton];
        
        
        // CGRectGetMaxY(titleLabel.frame)
        // self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, -15, CGRectGetWidth(self.frame)-14, CGRectGetMinY(self.bottomView.frame)-CGRectGetMaxY(titleLabel.frame))];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame)-10, self.bounds.size.height*0.43)];
        self.textView.delegate = self;
        
        self.textView.textColor = [UIColor grayColor];
        self.textView.text = self.textViewPlaceholder;
        // self.textView.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:0.95];
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.layer.borderWidth = 0.5;
        
        // self.textView.layer.cornerRadius = 5;
        self.textView.clipsToBounds = YES;
        
        self.textView.font =  [UIFont fontWithName:@"Lato-Regular" size:15];
        // [self addSubview:self.textView];
        
    }
    return self;
}

- (void)clickCancel
{
    [self.delegate cancelTextInput];
    [self removeFromSuperview];
}

- (void)clickSave
{
    [self.textView resignFirstResponder];
    
    if ([self.textView.text isEqualToString:@""] || [self.textView.text isEqualToString:self.textViewPlaceholder]) {
        NSLog(@"No input yet.");
    }
    else {
        [self.delegate finishTextInput:self.textView.text];
    }
    [self removeFromSuperview];
}

- (void)layoutSubviews
{
    // [self.textView becomeFirstResponder];
    
    
    SDCAlertController *alert = [SDCAlertController alertControllerWithTitle:self.title
                                                                     message:nil
                                                              preferredStyle:SDCAlertControllerStyleLegacyAlert];
    
    SDCAlertAction *cancelAction = [SDCAlertAction actionWithTitle:@"Cancel" style:SDCAlertActionStyleDefault handler:^(SDCAlertAction *action) {
        
        NSLog(@"SDCAlertAction cancel comment.........");
        [self clickCancel];
    }];
    
    SDCAlertAction *saveAction = [SDCAlertAction actionWithTitle:self.rightButtonTitle style:SDCAlertActionStyleDefault handler:^(SDCAlertAction *action) {
        
        NSLog(@"SDCAlertAction cancel comment.........");
        [self clickSave];
    }];
    
    
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    
    // This is too bad.
    NSLog(@"This is too bad - %f", self.superview.frame.size.width);
    if(self.superview.frame.size.width <= 320){
        self.textView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-12, self.bounds.size.height*0.40);
    }
    else if (self.superview.frame.size.width == 375) {
        self.textView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-67, self.bounds.size.height*0.40);
    }
    else {
        self.textView.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame)-106, self.bounds.size.height*0.40);
    }
    
    
    [alert.contentView addSubview:self.textView];
    
    [alert presentWithCompletion:^{
        // [self.textView becomeFirstResponder];
    }];
    
    
}



- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    /*
    if(textView.text.length == 0){
        textView.textColor = [UIColor grayColor];
        textView.text = self.textViewPlaceholder;
        // [textView resignFirstResponder];
    }
     */
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
