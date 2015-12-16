//
//  UIViewController+BBUserViewController.m
//  BBStory
//
//  Created by Fengzi on 15/12/4.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBUserViewController.h"
#import "BBAppDelegate.h"

@implementation BBUserViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    BBUserScrollView *userVC = [[BBUserScrollView alloc] initWithFrame:CGRectMake(0, 44, kDeviceWidth, kDeviceHeight)];
    userVC.delegate = self;
    [self.view addSubview:userVC];
    
}

- (void)pushInfoVC:(UIViewController *)viewController
{
    BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{}

@end
