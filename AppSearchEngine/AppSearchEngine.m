//
//  AppSearchEngine.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "AppSearchEngine.h"
#import "AFNetworking.h"
#import <testflighthub-Swift.h>
#import "Constants.h"

@implementation AppSearchEngine

+ (NSString *)appSearchUrl{
    return @"https://itunes.apple.com/search?";
}

-(void)searchWithTitle:(NSString*)title
               success:(void (^)(NSArray *apps))success
               failure:(void (^)(NSError *error))failure {
    
    NSMutableArray *apps = [[NSMutableArray alloc] init];
    
    // removed space....
    // Update later..... I remember it's not the space, "+"
    title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString* url = [NSString stringWithFormat:@"%@term=%@&entity=software&limit=%@", [AppSearchEngine appSearchUrl], title, kAppSearchEngineLimit];
    AFHTTPRequestOperationManager* operationManager = [AFHTTPRequestOperationManager manager];
    
    [operationManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Get results");
        NSArray *results = [responseObject objectForKey:@"results"];
        
        for (NSDictionary *result in results) {
            App *app = [[App alloc] initWithJson:result];
            [apps addObject:app];
        }
        
        success(apps);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to get results");
        failure(error);
    }];
}


@end
