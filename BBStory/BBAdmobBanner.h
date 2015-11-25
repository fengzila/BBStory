//
//  NSObject+BBBanner.h
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBBanner.h"
#import <GoogleMobileAds/GADBannerView.h>

@interface BBAdmobBanner : BBBanner
{
    GADBannerView *_adBannerView;
}

@end
