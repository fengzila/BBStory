//
//  BBBaseNavigationController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBNavigationController.h"

@interface BBNavigationController ()

@end

@implementation BBNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
//    {
//        [self.navigationBar setBackgroundColor:[UIColor blackColor]];
//        // 设置按钮色为白色
//        [self.navigationBar setTintColor:[UIColor whiteColor]];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
