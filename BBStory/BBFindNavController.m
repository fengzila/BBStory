//
//  UINavigationController+BBMainNavController.m
//  BBStory
//
//  Created by Fengzi on 15/6/9.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import "BBFindNavController.h"
#import "BBDataManager.h"

@implementation BBFindNavController

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button

- (void)openDrawer:(id)sender
{
    [[[BBDataManager getInstance] getDrawer] open];
}

@end
