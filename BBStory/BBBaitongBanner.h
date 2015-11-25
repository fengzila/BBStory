//
//  NSObject+BBBanner.h
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBanner.h"

#define IS_SHOW_AD_NOTIFICATION_NAME  @"isShowAdNotification"
#define IS_SHOW_WALL @"isShowWall"
#define IS_SHOW_BANNER @"isShowBanner"
#define IS_SHOW_SCREEN @"isShowScreen"

@interface BBBaitongBanner : BBBanner

- (void)showWall;
@end
