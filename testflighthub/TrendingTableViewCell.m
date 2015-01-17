//
//  TrendTableViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "TrendingTableViewCell.h"
#import <testflighthub-Swift.h>
#import <Colours.h>

@interface TrendingTableViewCell()

@property(nonatomic) BOOL isFirstLoad;  // No use how to setup.



@end

@implementation TrendingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
        // self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.product = [[Product alloc] initWithParseClassName:@"ATempName"];
        self.alreadyLike = NO;
        
        self.allLikeCount = 0;
        
        self.iconImageView = [[PFImageView alloc] init];
        self.iconImageView.frame = CGRectMake(10.0f, 10.0f, 90, 160);
        // [self.iconImageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
        // [self.iconImageView.layer setBorderWidth: 0.5];
        self.iconImageView.layer.cornerRadius = 5;
        self.iconImageView.clipsToBounds = YES;
        
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor grayColor];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
        // self.timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.timeLabel];
        
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17.0];
        self.nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:54.0/255.0 blue:54.0/255.0 alpha:1.0];
        
        self.descriptionLabel = [[YQLabel alloc] init];
        self.descriptionLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.descriptionLabel.yqNumberOfLine = 2;
        self.descriptionLabel.textColor = [UIColor blackColor];
        
        self.taglineLabel = [[YQLabel alloc] init];
        self.taglineLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.taglineLabel.yqNumberOfLine = 1;
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.descriptionLabel];
        [self addSubview:self.taglineLabel];
        
        CGFloat buttonWidth = 55;
        CGFloat buttonHeight = 30;
        
        
        
        self.getButton = [[AYVibrantButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-buttonWidth-16, CGRectGetHeight(self.frame)-buttonHeight-16, buttonWidth, buttonHeight) style:AYVibrantButtonStyleInvert];
        // self.getButton.vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        self.getButton.vibrancyEffect = nil;
        self.getButton.text = @"GET";
        self.getButton.font = [UIFont fontWithName:@"Lato-Bold" size:15.0];
        
        
        // self.getButton.cornerRadius = buttonHeight*0.5;
        self.getButton.cornerRadius = 5;
        self.getButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        
        [self.getButton addTarget:self action:@selector(goToAppStore:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.getButton];
        
        
        self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        self.likeButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        self.likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.likeButton addTarget:self action:@selector(tapLikeButton:) forControlEvents:UIControlEventTouchUpInside];
        // self.likeButton.backgroundColor = [UIColor redColor];
        
        [self.likeButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self addSubview:self.likeButton];
        
        
        
        self.likeCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        self.likeCountLabel.text = @"";
        self.likeCountLabel.font = [UIFont fontWithName:@"Lato-Regular" size:15.0];
        self.likeCountLabel.textColor = [UIColor grayColor];
        [self addSubview:self.likeCountLabel];
    }
    return self;
}

- (void) setContentValue:(Product*)product object:(PFObject*)object
{
    if (product.isLoadingIconImage) {
        self.iconImageView.file = [object objectForKey:@"iconImage"];
        if (self.iconImageView.file) {
            [self.iconImageView loadInBackground:^(UIImage *image, NSError *error) {
                NSLog(@"successfully loading");
            }];
        }
        else {
            self.iconImageView.file = [object objectForKey:@"coverImage"];
            [self.iconImageView loadInBackground:^(UIImage *image, NSError *error) {
                NSLog(@"successfully loading");
            }];
        }
        
    }
    else {
        self.iconImageView.image = product.iconImage;
    }
    
    self.nameLabel.text = [object objectForKey:@"name"];
    
    
    //cell.descriptionLabel.text = [object objectForKey:@"appDescription"];
    NSString *tempDescription = [object objectForKey:@"tagline"];
    self.descriptionLabel.text = [tempDescription stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    // self.taglineLabel.text = [object objectForKey:@"tagline"];
    
    // This is another version.
    self.taglineLabel.text = [NSString stringWithFormat:@"via %@", product.postedByUsername];
    self.taglineLabel.textColor = [UIColor grayColor];
    self.taglineLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13];
    // self.descriptionLabel.text = [[object objectForKey:@"tagline"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    // self.descriptionLabel.textColor = [UIColor blackColor];
    // self.descriptionLabel.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    
    self.product = product;
    if (product.isLoadingAlreadyLike) {
        [self checkLikeOnParse:product success:^(BOOL alreadyLike) {
            self.alreadyLike = alreadyLike;
        }];
    }
    else {
        self.alreadyLike = product.alreadyLike;
    }
    
    self.timeLabel.text = [object.createdAt shortTimeAgoSinceNow];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    // self.iconImageView.frame = CGRectMake( 16.0f, 10.0f, 90, 160); // 120x213, 60x113.6, 96X170, 90x160
    self.iconImageView.frame = CGRectMake(16.0f, 16.0f, 50, 50);
    
    self.nameLabel.frame = CGRectMake(82.0f, 15.0f, CGRectGetWidth(self.frame)-132, 28);
    
    self.timeLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-70, CGRectGetMinY(self.nameLabel.frame), 55, 30);
    
    [self.descriptionLabel setFrame:CGRectMake(82.0f, 70.0f, CGRectGetWidth(self.frame)-100, 50) font:self.descriptionLabel.font text:self.descriptionLabel.text];
    
    [self.taglineLabel setFrame:CGRectMake(82.0f, CGRectGetMaxY(self.nameLabel.frame)+2, CGRectGetWidth(self.frame)-100, 50) font:self.taglineLabel.font text:self.taglineLabel.text];
    
    self.getButton.backgroundColor = [UIColor infoBlueColor];
    
    self.likeButton.frame = CGRectMake(82.0f, CGRectGetMinY(self.getButton.frame)-10, 60, 50);
    self.likeCountLabel.frame = CGRectMake(CGRectGetMaxX(self.likeButton.frame)-20, CGRectGetMinY(self.getButton.frame), 80, 30); // 40 is good.
}

- (void)goToAppStore:(UIButton*)button
{
    if (self.product.isOnAppStore) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get the App" message:@"You are going to share your email to the creator of the beta testing app." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Share", nil];
        [alertView show];
    }
    else {
        [self.delegate openWebsiteWithAddress:self.product.website];
    }
}

#pragma mark - UIAlertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1: {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thank you" message:@"You will receive the invitation to the app soon. Hope you enjoy the app." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default:
            break;
    }
}


- (void)tapLikeButton:(UIButton*)button
{
    if (self.alreadyLike) {
        [self deleteLike];
        self.alreadyLike = NO;
        // [[LikesDataManager sharedInstance] addLike:self.product];
        [[LikesDataManager sharedInstance] addUpdate:self.product];
        self.allLikeCount = [NSNumber numberWithInt:[self.allLikeCount intValue] - 1];    // this number is updated locally after first load.
        
    }
    else {
        [self createLike];
        self.alreadyLike = YES;
        // [[LikesDataManager sharedInstance] removeLike:self.product];
        [[LikesDataManager sharedInstance] addUpdate:self.product];
        self.allLikeCount = [NSNumber numberWithInt:[self.allLikeCount intValue] + 1];
        
    }
    
}

- (void)createLike
{
    PFObject *like = [PFObject objectWithClassName:@"Like"];
    [like setObject:[PFUser currentUser]  forKey:@"user"];
    [like setObject:self.product.parseObject forKey:@"product"];
    
    
    [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"create like successfully.");
            // [self.likesFromProduct removeAllObjects];
            // [self.likesFromProduct addObject:like];
            
        }
    }];
}

- (void)setProduct:(Product *)product
{
    _product = product;
    
    
    // NSLog(@"%@", product.parseObject.objectId);
    if (product.parseObject.objectId == nil) {
        
    }
    else {
        [self getLikeCount];
        // self.allLikeCount = [NSNumber numberWithInteger: self.product.upvoteCount];
    }
}

- (void)setAlreadyLike:(BOOL)alreadyLike
{
    _alreadyLike = alreadyLike;
    if (alreadyLike) {
        [self.likeButton setTitle:@"Liked" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor infoBlueColor] forState:UIControlStateNormal];
    }
    else {
        [self.likeButton setTitle:@"Like" forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8] forState:UIControlStateNormal];
    }
}

/// We will check whether users change the like. If he does, load likes from parse. If not, load directly from local data manager.
- (void)getLikeCount
{
    if ([[LikesDataManager sharedInstance] checkUpdate:self.product]) {
        
        NSLog(@"get like Count On parse");
        
        PFQuery *query = [PFQuery queryWithClassName:@"Product"];
        [query getObjectInBackgroundWithId:self.product.parseObject.objectId block:^(PFObject *object, NSError *error) {
            
            self.allLikeCount = [object objectForKey:@"upvoteCount"];
        }];
    }
    else {
        self.allLikeCount = [NSNumber numberWithInteger:self.product.upvoteCount];
    }
}


- (void)setAllLikeCount:(NSNumber *)allLikeCount
{
    _allLikeCount = allLikeCount;
    if (_allLikeCount == 0) {
        self.likeCountLabel.text = @"0";
    }
    else {
        self.likeCountLabel.text = allLikeCount.stringValue;
    }
}

- (void)checkLikeOnParse:(Product *)product success:(void (^)(BOOL))success
{
    NSLog(@"check like On Parse in Trending Table View Cell");
    if ([[UserManager sharedInstance] checkUserIsAvailable]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Like"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"product" equalTo:self.product.parseObject];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error && objects.count>0) {
                success(YES);
                
            }
            else {
                success(NO);
                
            }
        }];
    }
    else {
        success(NO);
    }
}

- (void)deleteLike
{
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"product" equalTo:self.product.parseObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count>0) {
            
            [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    
                }
            }];
            
        }
        else {
        }
    }];
}

+ (CGFloat)cellHeight
{
    return 160+5; // two lines... 150
    // three lines is 160+10
}


@end
