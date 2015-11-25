//
//  UIView+BBBannerManager.m
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBBannerManager.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "BBAdmobBanner.h"
#import "BBBaitongBanner.h"

@implementation BBBannerManager
+ (id)getInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(void)requestWithViewController:(UIViewController*)vc;
{
    int randomValue = (arc4random() % 100) + 0;
    if (randomValue < 150) {
        _bannerType = kAdmob;
        _banner = [[BBAdmobBanner alloc] init];
    } else {
        _bannerType = kBaitong;
        _banner = [[BBBaitongBanner alloc] init];
    }
    [_banner requestWithViewController:vc];
}

-(void)showWithAnimationDuration:(CGFloat)durationTime
{
    [_banner showWithAnimationDuration:durationTime];
}
-(void)hideWithAnimationDuration:(CGFloat)durationTime
{
    [_banner hideWithAnimationDuration:durationTime];
}

-(void)showBaitongWall
{
    [[[BBBaitongBanner alloc] init] showWall];
}

@end
