//
//  AppSearchEngine.h
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSearchEngine : NSObject

-(void)searchWithTitle:(NSString*)title
               success:(void (^)(NSArray *apps))success
               failure:(void (^)(NSError *error))failure;

@end
