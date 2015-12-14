//
//  BBMainViewController.h
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBItemView.h"

@interface BBTabbarViewController : UITabBarController <BBItemViewDelegate>
{
@private
    UIView *_tabbarBg;
    NSArray *_imgs;
    NSArray *_titles;
    NSArray *_pos;
    NSMutableArray *_tabbarItemArr;
}

@property (nonatomic, readonly) UIView *tabbarBg;
- (void)showTabBarWithAnimationDuration:(CGFloat)durationTime;
- (void)hideTabBarWithAnimationDuration:(CGFloat)durationTime;
+ (BBTabbarViewController*)mainVCInstance;
@end
