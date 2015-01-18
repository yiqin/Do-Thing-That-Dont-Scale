//
//  ProductWebsiteViewController.m
//  testflighthub
//
//  Created by Yi Qin on 1/17/15.
//  Copyright (c) 2015 Yi Qin. All rights reserved.
//

#import "ProductWebsiteViewController.h"

@interface ProductWebsiteViewController ()

@end

@implementation ProductWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBarUIViewTwo" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabBarUIViewTwo" object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"showTabBarUIViewTwo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
