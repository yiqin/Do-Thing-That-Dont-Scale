//
//  ProfileViewController.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProfileViewController.h"
#import "Colours.h"
#import <SVProgressHUD.h>
#import <Parse/Parse.h>

#import <TwitterKit/TwitterKit.h>   // Not user any more.

@interface ProfileViewController()
@property (strong, nonatomic) UIView *profileBackground;

@property (nonatomic) CGFloat userPhotoSize;
@property (strong, nonatomic) UIImageView *userPhoto;

@property (strong, nonatomic) UILabel *usernameLabel;

@property (strong, nonatomic) UIButton *accountButton;


@property (strong, nonatomic) ProfileSelectionTableViewController *profileSelectionTVC;


@end

@implementation ProfileViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [TestMixpanel enteredProfile];
    
    self.title = @"";
    
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateNew) name:@"showCreateNewFromProfile" object:nil];
    
    [self.tabBarController.tabBar setFrame:CGRectZero];
    
    UIColor *tempColor = [UIColor colorFromHexString:@"a6c690"];
    
    self.profileBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];     // temp value
    [self.view addSubview:self.profileBackground];
    self.profileBackground.backgroundColor = tempColor;
    
    self.userPhotoSize = 100.0;
    
    self.userPhoto = [[UIImageView alloc] init];
    
    
    if ([UserManager sharedInstance].hasLoginWithTwitter) {
        self.userPhoto.image = [UserManager sharedInstance].profileImage;
        NSLog(@"has login....");
    }
    else {
        self.userPhoto.image = [UIImage imageNamed:@"profile"];
        self.userPhoto.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.98];
        NSLog(@"NOooooooo login....");
    }
    
    self.userPhoto.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.userPhoto];
    
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    if (![[UserManager sharedInstance] checkUserLoginWithTwitter]) {
        self.usernameLabel.text = @"UNKNOWN";
    }
    else {
        self.usernameLabel.text = [[UserManager sharedInstance].name uppercaseString];
    }
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    self.usernameLabel.textColor = [UIColor whiteColor];
    [self.view addSubview: self.usernameLabel];
    
    self.accountButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.accountButton addTarget:self action:@selector(tapAccountButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.accountButton setTitleColor:[UIColor colorWithRed:85.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.accountButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8] forState:UIControlStateHighlighted];
    
    
    [self.accountButton.layer setBorderColor: [[UIColor colorWithRed:85.0/255.0 green:172.0/255.0 blue:238.0/255.0 alpha:1.0] CGColor]];
    [self.accountButton.layer setBorderWidth: 1];
    self.accountButton.tag = 0;
    [self.view addSubview:self.accountButton];
    /*
    if (![[UserManager sharedInstance] checkUserLoginWithTwitter]) {
        [self.view addSubview:self.accountButton];
    }
    */
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    self.profileSelectionTVC = [[ProfileSelectionTableViewController alloc] initWithNibName:nil bundle:nil];
    self.profileSelectionTVC.delegate = self;
    self.navigationController.delegate = nil;
    [self.view addSubview:self.profileSelectionTVC.view];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserManager sharedInstance] checkUserLoginWithTwitter]) {
        self.userPhoto.image = [UIImage imageNamed:@"profile"];
        self.userPhoto.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.98];
        self.usernameLabel.text = @"UNKNOWN";
    }
    else {
        self.userPhoto.image = [UserManager sharedInstance].profileImage;
        self.usernameLabel.text = [[UserManager sharedInstance].name uppercaseString];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIFont *tempFont1;
    UIFont *tempFont2;
    
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    
    // iPhone 6
    if (self.view.frame.size.width >= 375) {
        self.profileBackground.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 152);
        self.userPhotoSize = 100;
        tempFont1 = [UIFont fontWithName:@"OpenSans-Bold" size:20.0];
        tempFont2 = [UIFont fontWithName:@"Lato-Regular" size:20.0];
        
        buttonWidth = (100+30)*1.5;
        buttonHeight = 34;
        self.accountButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:17];
        self.accountButton.frame = CGRectMake((CGRectGetWidth(self.view.frame)-buttonWidth)*0.5, CGRectGetHeight(self.profileBackground.frame)+self.userPhotoSize*0.5+20, buttonWidth, buttonHeight);
        self.accountButton.layer.masksToBounds = YES;
        self.accountButton.layer.cornerRadius = buttonHeight*0.5;
    }
    // iphone 5
    else {
        self.profileBackground.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 132);
        self.userPhotoSize = 86;
        tempFont1 = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
        tempFont2 = [UIFont fontWithName:@"Lato-Regular" size:18.0];
        
        buttonWidth = (86+30)*1.5;
        buttonHeight = 30;
        self.accountButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15];
        self.accountButton.frame = CGRectMake((CGRectGetWidth(self.view.frame)-buttonWidth)*0.5, CGRectGetHeight(self.profileBackground.frame)+self.userPhotoSize*0.5+20, buttonWidth, buttonHeight);
        self.accountButton.layer.masksToBounds = YES;
        self.accountButton.layer.cornerRadius = buttonHeight*0.5;
    }
    
    [self.usernameLabel setFont:tempFont1];
    self.usernameLabel.frame = CGRectMake(0, CGRectGetHeight(self.profileBackground.frame)-self.userPhotoSize*0.5-46, CGRectGetWidth(self.view.frame), 30);
    
    
    
    
    self.userPhoto.layer.masksToBounds = YES;
    self.userPhoto.layer.cornerRadius = self.userPhotoSize*0.5;
    self.userPhoto.frame = CGRectMake((CGRectGetWidth(self.profileBackground.frame)-self.userPhotoSize)*0.5, CGRectGetHeight(self.profileBackground.frame)-self.userPhotoSize*0.5, self.userPhotoSize, self.userPhotoSize);
    
    /*
    if (self.accountButton.tag == 0) {
        [self.accountButton setTitle:@"Sign Up With Twitter" forState:UIControlStateNormal];
    }
    else {
        [self.accountButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    */
    
    if (![[UserManager sharedInstance] checkUserLoginWithTwitter]) {
        [self.accountButton setTitle:@"Sign Up With Twitter" forState:UIControlStateNormal];
    }
    else {
        [self.accountButton setTitle:@"Log Out" forState:UIControlStateNormal];
        self.accountButton.frame = CGRectMake(CGRectGetMinX(self.accountButton.frame)+CGRectGetWidth(self.accountButton.frame)*0.15, CGRectGetMinY(self.accountButton.frame), CGRectGetWidth(self.accountButton.frame)*0.7, CGRectGetHeight(self.accountButton.frame));
    }
    
    
    self.profileSelectionTVC.view.frame = CGRectMake(0, CGRectGetMaxY(self.accountButton.frame)+30, CGRectGetWidth(self.view.frame), 44*[ProfileSelectionTableViewController numberOfRows]);
}

- (void)showCreateNew {
    
    // Circle
    // [self performSegueWithIdentifier:@"PushSegure4" sender:self];
    
    CreateNewViewController *createNewVC = [[CreateNewViewController alloc] init];
    createNewVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:createNewVC animated:YES completion:^{
        
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tapAccountButton:(UIButton*)button {
    if (![[UserManager sharedInstance] checkUserLoginWithTwitter]) {
        [TestMixpanel login];
        [SVProgressHUD show];
        
        [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. The user cancelled the Twitter login.");
                [TestMixpanel loginFail];
                return;
            } else if (user.isNew) {
                NSLog(@"User signed up and logged in with Twitter!");
                [TestMixpanel loginSuccessFromProfileView];
                
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"login"];
                [[UserManager sharedInstance] updateUserInfoFromTwitterUsername];
                [self viewFromUnloginToLogin];
            } else {
                NSLog(@"User logged in with Twitter!");
                [TestMixpanel loginSuccessFromProfileView];
                
                [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"login"];
                [[UserManager sharedInstance] updateUserInfoFromTwitterUsername];
                [self viewFromUnloginToLogin];
            }     
        }];
    }
    else {
        // Logout.....
        // We use fake logout here.
        // [PFUser logOut];
        [TestMixpanel logout];
        [SVProgressHUD show];
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismissSVProgreeHUB) userInfo:nil repeats:false];
    }
}

- (void)dismissSVProgreeHUB {
    [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"login"];
    [UserManager sharedInstance].hasLoginWithTwitter = false;
    [self.accountButton removeFromSuperview];
    [self viewDidLoad];
    [SVProgressHUD dismiss];
}

- (void)viewFromUnloginToLogin {
    
    
    [[UserManager sharedInstance] updateUserInfoFromTwitterUsername];
    [self.accountButton removeFromSuperview];
    // [self.accountButton setTitle:@"Log Out" forState:UIControlStateNormal];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reloadUserPhoto) userInfo:nil repeats:false];
    
    // No need this.........
    [self viewDidLoad];
    [self viewWillAppear:true];
}

// This is bad.........
- (void)reloadUserPhoto {
    self.userPhoto.image = [UserManager sharedInstance].profileImage;
    self.usernameLabel.text = [[UserManager sharedInstance].name uppercaseString];
    
    [SVProgressHUD dismiss];
}


- (void)goToYourRecommendations {
    // YourRecommendationsTableViewController *yourRecommendationsTVC = [[YourRecommendationsTableViewController alloc] initWithNibName:nil bundle:nil];
    // [self.navigationController pushViewController:yourRecommendationsTVC animated:true];
    
    [self performSegueWithIdentifier:@"goToYourRecommendations" sender:self];
}

- (void)goToYourLikes {
    // YourLikesTableViewController *yourLikesTVC = [[YourLikesTableViewController alloc] initWithNibName:nil bundle:nil];
    // [self.navigationController pushViewController:yourLikesTVC animated:true];
    
    [self performSegueWithIdentifier:@"goToYourLikes" sender:self];
}

@end
