//
//  HomeTabBarController.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "HomeTabBarController.h"
#import "YQButton.h"
#import <testflighthub-Swift.h>

@interface HomeTabBarController ()

@property (nonatomic) int previousSelectedIndex;

@property (strong, nonatomic) YQButtonWithImage *button0;
@property (strong, nonatomic) YQButtonWithImage *button1;
@property (strong, nonatomic) YQButtonWithImage *button2;
@property (strong, nonatomic) YQButtonWithImage *button3;
@property (strong, nonatomic) YQButtonWithImage *button4;

@end

@implementation HomeTabBarController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.previousSelectedIndex = 0;
        
        self.tabBarUIView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-45, CGRectGetWidth(self.view.frame), 45)];
        self.tabBarUIView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.98];
        self.tabBarUIView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:self.tabBarUIView];
        
        [self addCustomTabBar];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popFromCreateNewViewController) name:@"popFromCreateNewViewController" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBarUIView) name:@"hideTabBarUIView" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarUIView) name:@"showTabBarUIView" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideTabBarUIViewTwo) name:@"hideTabBarUIViewTwo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarUIViewTwo) name:@"showTabBarUIViewTwo" object:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.hidden = YES;   // Finally it works here.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tabBar.hidden = YES;   // it doens't work at all.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addCustomTabBar {
    
    UIViewAutoresizing buttonAutoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //**************************//
    // change button number here.
    //**************************//
    int buttonNumber = 5;
    CGFloat buttonWidth = CGRectGetWidth(self.tabBarUIView.frame)/buttonNumber;  // five buttons
    
    if (buttonNumber == 5) {
        // Button0
        self.button0 = [[YQButtonWithImage alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 45) image:@"trending_unselected" selectedImage:@"trending_selected"];
        self.button0.autoresizingMask = buttonAutoresizingMask;
        // [self.button0 setTitle:@"0" forState:UIControlStateNormal];
        [self.button0 setTag:0];
        [self.button0 setSelected:true];
        [self.button0 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        // self.button0.selectedColor = [UIColor redColor]; // it's too late to setup here.
        [self.tabBarUIView addSubview:self.button0];
        
        // Button1
        self.button1 = [[YQButtonWithImage alloc] initWithFrame:CGRectMake(buttonWidth, 0, buttonWidth, 45) image:@"recent_unselected" selectedImage:@"recent_selected"];
        self.button1.autoresizingMask = buttonAutoresizingMask;
        // [self.button1 setTitle:@"1" forState:UIControlStateNormal];
        [self.button1 setTag:1];
        [self.button1 setSelected:false];
        [self.button1 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarUIView addSubview:self.button1];
        
        // Button2
        self.button2 = [[YQButtonWithImage alloc] initWithFrame:CGRectMake(2*buttonWidth, 0, buttonWidth, 45) image:@"add_unselected" selectedImage:@"add_selected"];
        self.button2.autoresizingMask = buttonAutoresizingMask;
        // [self.button2 setTitle:@"2" forState:UIControlStateNormal];
        [self.button2 setTag:2];
        [self.button2 setSelected:false];
        [self.button2 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarUIView addSubview:self.button2];
        
        // Button3
        self.button3 = [[YQButtonWithImage alloc] initWithFrame:CGRectMake(3*buttonWidth, 0, buttonWidth, 45) image:@"notification_unselected" selectedImage:@"notification_selected"];
        self.button3.autoresizingMask = buttonAutoresizingMask;
        // [self.button3 setTitle:@"3" forState:UIControlStateNormal];
        [self.button3 setTag:3];
        [self.button3 setSelected:false];
        [self.button3 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarUIView addSubview:self.button3];
        
        // Button4
        self.button4 = [[YQButtonWithImage alloc] initWithFrame:CGRectMake(4*buttonWidth, 0, buttonWidth, 45) image:@"profile_unselected" selectedImage:@"profile_selected"];
        self.button4.autoresizingMask = buttonAutoresizingMask;
        // [self.button4 setTitle:@"4" forState:UIControlStateNormal];
        [self.button4 setTag:4];
        [self.button4 setSelected:false];
        [self.button4 addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarUIView addSubview:self.button4];
    }
}

- (void)tabBarButtonClicked:(id)sender
{
    int tagNum = (int)[sender tag];
    if (tagNum != self.selectedIndex) {
        
    }
    [self selectTab:tagNum];
    
    NSLog(@"select session: %lu", (unsigned long)self.selectedIndex);
}

- (void)selectTab:(int)tabID
{
    // no need to check
    /*
    if (self.previousSelectedIndex != tabID) {
        switch(tabID) {
            case 0:
                [self selectButton0];
                break;
            case 1:
                [self selectButton1];
                break;
            case 2:
                [self selectButton2];
                break;
            case 3:
                [self selectButton3];
                break;
            case 4:
                [self selectButton4];
                break;
            default:
                break;
        }
    }
     */
    switch(tabID) {
        case 0:
            [self selectButton0];
            break;
        case 1:
            [self selectButton1];
            break;
        case 2:
            [self selectButton2];
            break;
        case 3:
            [self selectButton3];
            break;
        case 4:
            [self selectButton4];
            break;
        default:
            break;
    }

}

-(void)selectButton0
{
    [self.button0 setSelected:true];
    [self.button1 setSelected:false];
    [self.button2 setSelected:false];
    [self.button3 setSelected:false];
    [self.button4 setSelected:false];
    [self changeTabBar:0];
}

-(void)selectButton1
{
    [self.button0 setSelected:false];
    [self.button1 setSelected:true];
    [self.button2 setSelected:false];
    [self.button3 setSelected:false];
    [self.button4 setSelected:false];
    [self changeTabBar:1];
}

-(void)selectButton2
{
    // A potential bug: if we don't hide tabBarUIView........., multiply CreateNewViewController could be created.
    [self hideTabBarUIView];
    
    // Middle animation
    /*
    [self.button0 setSelected:false];
    [self.button1 setSelected:false];
    [self.button2 setSelected:true];
    [self.button3 setSelected:false];
    [self.button4 setSelected:false];
    */
    
    switch(self.previousSelectedIndex) {
        case 0:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreateNewFromTrending" object:self];
            [TestMixpanel enteredCreateView:@"Trending View"];
            break;
        case 1:
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreateNewFromRecents" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreateNewFromRecents11" object:self];
            [TestMixpanel enteredCreateView:@"Recent View"];
            break;
        case 2:
            break;
        case 3:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreateNewFromNotification" object:self];
            [TestMixpanel enteredCreateView:@"Notification View"];
            break;
        case 4:
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showCreateNewFromProfile" object:self];
            [TestMixpanel enteredCreateView:@"Profile View"];
            break;
        default:
            break;
    }
    [self.button2 setSelected:false];
}

-(void)selectButton3
{
    [self.button0 setSelected:false];
    [self.button1 setSelected:false];
    [self.button2 setSelected:false];
    [self.button3 setSelected:true];
    [self.button4 setSelected:false];
    [self changeTabBar:3];
}

-(void)selectButton4
{
    [self.button0 setSelected:false];
    [self.button1 setSelected:false];
    [self.button2 setSelected:false];
    [self.button3 setSelected:false];
    [self.button4 setSelected:true];
    [self changeTabBar:4];
}

-(void)changeTabBar:(int)tabID
{
    // Save this value for the back animation
    self.previousSelectedIndex = tabID;
    
    // If it's 3 or 4, minus 1
    if (tabID > 2) {
        tabID = tabID -1;
    }
    
    [self setSelectedIndex:tabID];
}

-(void)popFromCreateNewViewController
{
    self.tabBarUIView.hidden = NO;
}

-(void)hideTabBarUIView
{
    // No Circle now, so no need to hidden
    // self.tabBarUIView.hidden = YES;
}

-(void)showTabBarUIView
{
    self.tabBarUIView.hidden = NO;
}

-(void)hideTabBarUIViewTwo
{
    self.tabBarUIView.hidden = YES;
}

-(void)showTabBarUIViewTwo
{
    self.tabBarUIView.hidden = NO;
}

@end
