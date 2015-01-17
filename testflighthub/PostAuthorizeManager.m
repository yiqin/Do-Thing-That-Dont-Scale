//
//  PostAuthorizeManager.m
//  testflighthub
//
//  Created by Yi Qin on 1/9/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "PostAuthorizeManager.h"
#import <Parse/Parse.h>

@interface PostAuthorizeManager()

@property(nonatomic) BOOL isAuthorized;

@end

@implementation PostAuthorizeManager

+ (instancetype)sharedManager
{
    static PostAuthorizeManager *sharedYQManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedYQManager = [[self alloc] init];
    });
    return sharedYQManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _isAuthorized = NO;
    }
    return self;
}

+ (void)setAuthorize
{
    PostAuthorizeManager *shared = [PostAuthorizeManager sharedManager];
    shared.isAuthorized = [[[PFUser currentUser] objectForKey:@"isAuthorized"] boolValue];
}

+ (BOOL)getAuthorize
{
    PostAuthorizeManager *shared = [PostAuthorizeManager sharedManager];
    return shared.isAuthorized;
}

@end
