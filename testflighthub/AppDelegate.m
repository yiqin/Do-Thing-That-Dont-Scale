//
//  AppDelegate.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <Mixpanel.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>
#import <testflighthub-Swift.h>
#import "YQParse.h"
#import "PostAuthorizeManager.h"
#import <SVProgressHUD.h>
#import <Colours.h>
#import "YO.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 455A64
    // 607D8B
    // UIColor(red: 41.0/255.0, green: 45.0/255.0, blue: 53.0/255.0, alpha: 0.8)
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:41.0/255.0 green:45.0/255.0 blue:53.0/255.0 alpha:0.8]];
    // White or black
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    // Set status bar style
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Lata-Regular" size:21.0], NSFontAttributeName, nil]];
    
    // Mixpanel
    [Mixpanel sharedInstanceWithToken:@"7184be430ae767d71673b3e056afe18e"];
    [TestMixpanel start];
    
    // Parse.com
    [Parse setApplicationId:@"E7StxK5eRXAok9R4Ohen8TjNxspF7N97ogokzsSa"
                  clientKey:@"yFGfgZcREb2bFc03jkOCpgDEof5WDCeLI4stOMM3"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [UserManager sharedInstance];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        [[UserManager sharedInstance] setUserAvailable];
        [TestMixpanel setName];    // I agree this is not the best solution. It shouldn't be called every time.
    } else {
        // show the signup or login screen
        [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
            if (error) {
                NSLog(@"Anonymous login failed.");
            } else {
                NSLog(@"Anonymous user logged in.");
                [TestMixpanel setName];     // As Mixpenal has its own ID. No need I think.
            }
        }];
    }
    
    // Update Post Authorize (I spent three hours to fix this.)
    // As current User is nil, this funcion won't be called when the app is loaded for the first time.
    [currentUser fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            NSLog(@"No Need. It's error");
        }
        else {
            NSLog(@"Refresh");
            [PostAuthorizeManager setAuthorize];
        }
    }];
    
    // Fabric
    [Fabric with:@[CrashlyticsKit, TwitterKit]];
    
    // Login with Twitter
    [PFTwitterUtils initializeWithConsumerKey:@"Y6aEBAuhfdykIB2GRKlzhsUkD" consumerSecret:@"S5WRV7T26S3As9UgwW0APLeOeC7Rh4OrM9T5zeZzjh9FC4w6XM"];
    
    [[UserManager sharedInstance] updateUserInfoFromTwitterUsername];
    
    // [CloudCodeManager sendTestHello];
    [ConfigDataManager startToRetrieveConfig];
    [DeviceManager sharedInstance];
    [LikesDataManager sharedInstance];
    
    // YQParse To Notification Center
    [YQParse setApplicationId:@"E7StxK5eRXAok9R4Ohen8TjNxspF7N97ogokzsSa"
                   restApiKey:@"cIJOjSLqENsdhupxy5iBA3yST0B6eKxqh3908GR6"];
    
    // Setting SVProgress
    [SVProgressHUD setForegroundColor:[UIColor colorFromHexString:@"00a0e9"]];
    [SVProgressHUD setRingThickness:4.00];
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    
    
    // YO Notification
    [YO startWithAPIKey:@"8c334719-387e-44b8-84b3-d36ae1228e53"];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "info.yiqin.testflighthub" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"testflighthub" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"testflighthub.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

// This is crazy.................................
@implementation UINavigationItem (myCustomization)

-(UIBarButtonItem *)backBarButtonItem
{
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

@end
