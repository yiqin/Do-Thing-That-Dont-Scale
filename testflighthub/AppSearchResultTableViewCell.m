//
//  AppSearchResultTableViewCell.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "AppSearchResultTableViewCell.h"
#import "AFNetworking.h"
#import <testflighthub-Swift.h>

@implementation AppSearchResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"init table celll");
        self.appNameLabel = [[UILabel alloc] init];
        // self.appNameLabel.backgroundColor = [UIColor yellowColor];
        [self addSubview:self.appNameLabel];
        
        self.authorLabel = [[UILabel alloc] init];
        self.authorLabel.textColor = [UIColor grayColor];
        self.authorLabel.font = [UIFont systemFontOfSize:13];
        // self.authorLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.authorLabel];
        
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.iconImageView];
        
        self.appDescriptionLabel = [[YQLabel alloc] init];
        self.appDescriptionLabel.yqNumberOfLine = 3;
        self.appDescriptionLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.appDescriptionLabel];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"init table cell");
        
        
    }
    return self;
}

- (void)setApp:(App *)app
{
    _app = app;
    
    if (app.isLoadingArtwork100) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:app.artworkUrl100]];
        
        AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Response: %@", responseObject);
            self.iconImageView.image = responseObject;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Image error: %@", error);
            
        }];
        [requestOperation start];
    }
    else {
        self.iconImageView.image = app.artwork100;
    }
    
    self.appNameLabel.text = app.trackName;
    self.authorLabel.text = [NSString stringWithFormat:@"Created by %@", app.artistName];
    self.appDescriptionLabel.text = app.appDescription;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat tempX = 82.0f;
    self.appNameLabel.frame = CGRectMake(tempX, 4, CGRectGetWidth(self.frame)-tempX-10, 28);
    self.authorLabel.frame = CGRectMake(tempX, CGRectGetMaxY(self.appNameLabel.frame)-5, CGRectGetWidth(self.frame)-tempX-10, 22);
    self.iconImageView.frame = CGRectMake(16, 10, 50, 50);
    
    [self.appDescriptionLabel setFrame:CGRectMake(tempX, 60.0f, CGRectGetWidth(self.frame)-tempX-2, 50) font:self.appDescriptionLabel.font text:self.appDescriptionLabel.text];
}

+ (CGFloat)cellHeight
{
    return 130;
}

@end
