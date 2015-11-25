//
//  NSObject+BBBanner.m
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBAdmobBanner.h"

@implementation BBAdmobBanner

- (void)requestWithViewController:(UIViewController*)vc
{
    if (kDeviceWidth > 640) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    CGRect frame = _adBannerView.frame;
    _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
    _adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adBannerView.rootViewController = vc;
    [vc.view addSubview:_adBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adBannerView loadRequest:[GADRequest request]];
}
-(void)showWithAnimationDuration:(CGFloat)durationTime
{
    CGRect frame = _adBannerView.frame;
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0, frame.size.width, frame.size.height);
                     }];
}
-(void)hideWithAnimationDuration:(CGFloat)durationTime
{
    CGRect frame = _adBannerView.frame;
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, -frame.size.height, frame.size.width, frame.size.height);
                     }];
}

@end
