//
//  UIView+BBBannerManager.h
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BBBanner.h";

typedef enum {
    kAdmob = 0,
    kBaitong
}BannerType;

@interface BBBannerManager : NSObject{
    BannerType _bannerType;
    BBBanner* _banner;
}

+(BBBannerManager *)getInstance;
-(void)requestWithViewController:(UIViewController*)vc;
-(void)showWithAnimationDuration:(CGFloat)durationTime;
-(void)hideWithAnimationDuration:(CGFloat)durationTime;
-(void)showBaitongWall;
@end
