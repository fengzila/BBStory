//
//  NSObject+BBBanner.m
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBBaitongBanner.h"
#import "BTPlatform.h"

@interface BBBaitongBanner ()

@property (assign, nonatomic) BOOL isShowBanner;
@property (assign, nonatomic) BOOL isShowScreen;
@property (assign, nonatomic) BOOL isShowWall;
@property (assign, nonatomic) UIViewController* curVC;

@end

@implementation BBBaitongBanner

- (id)init {
    self = [super init];
    if (self) {
        self.isShowBanner = YES;
        self.isShowScreen = YES;
        self.isShowWall = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPlatformStatus:) name:PLATFORMSTATUS_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callIsShowAd:) name:IS_SHOW_AD_NOTIFICATION_NAME object:nil];
    }
    return self;
}

- (void)callPlatformStatus:(NSNotification *)notification {
    BOOL boolean = [notification.object intValue];
    if (boolean) {
        NSLog(@"可用");
    } else  {
        NSLog(@"停用");
    }
}

- (void)callIsShowAd:(NSNotification *)notification {
    NSDictionary *info = notification.object;
    self.isShowWall = [info[IS_SHOW_WALL] intValue] == 1 ? YES : NO;
    self.isShowScreen = [info[IS_SHOW_SCREEN] intValue] == 1 ? YES : NO;
    self.isShowBanner = [info[IS_SHOW_BANNER] intValue] == 1 ? YES : NO;
}

- (void)showInsertScreen {
    if (self.isShowScreen) {
        [[BTPlatform sharedInstance] showInsertScreen];
    }
}

- (void)showWall {
    if (self.isShowWall) {
        [[BTPlatform sharedInstance] showWall];
    }
}

- (void)showTextBanner {
    if (self.isShowBanner) {
        UIView *textBanner = [self.curVC.view viewWithTag:2000];
        if (!textBanner) {
            [self buildTextBanenr];
        } else {
            if (textBanner.hidden) {
                [textBanner removeFromSuperview];
                [self buildTextBanenr];
            }
        }
    }
}

- (void)showPictureBanner {
    if (self.isShowBanner) {
        UIView *pictureBanner = [self.curVC.view viewWithTag:1000];
        if (!pictureBanner) {
            [self buildPictureBanner];
        }else {
            if (pictureBanner.hidden) {
                [pictureBanner removeFromSuperview];
                [self buildPictureBanner];
            }
        }
    }
}

- (void)buildPictureBanner {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = screenWidth;
    CGFloat height = screenHeight;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft | orientation == UIInterfaceOrientationLandscapeRight) {
        width = MAX(screenHeight, screenWidth);
        height = MIN(screenHeight, screenWidth);
    }
    height = IOS7_OR_LATER ? height : height - 20;
    UIView *pictureBanner = [[BTPlatform sharedInstance] pictureBannerWithPosition:CGPointMake((width - 320) / 2, height - 110)];
    pictureBanner.tag = 1000;
    [self.curVC.view addSubview:pictureBanner];
}

- (void)buildTextBanenr {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = screenHeight;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication]statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeLeft | orientation == UIInterfaceOrientationLandscapeRight) {
        height = MIN(screenHeight, screenWidth);
    }
    height = IOS7_OR_LATER ? height : height - 20;
    UIView *textBanner = [[BTPlatform sharedInstance] textBannerWithPosition:CGPointMake(0, height - 50)];
    textBanner.tag = 2000;
    [self.curVC.view addSubview:textBanner];
    
    CGRect frame = textBanner.frame;
    textBanner.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0, frame.size.width, frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0) {
    return  YES;
}

-(void)requestWithViewController:(UIViewController*)vc
{
    self.curVC = vc;
    [self showTextBanner];
}
-(void)showWithAnimationDuration:(CGFloat)durationTime
{
    UIView *textBanner = [self.curVC.view viewWithTag:2000];
    if (textBanner && !textBanner.hidden) {
        CGRect frame = textBanner.frame;
        [UIView animateWithDuration:durationTime
                         animations:^{
                             textBanner.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0, frame.size.width, frame.size.height);
                         }];
    }
}
-(void)hideWithAnimationDuration:(CGFloat)durationTime
{
    UIView *textBanner = [self.curVC.view viewWithTag:2000];
    if (textBanner && !textBanner.hidden) {
        CGRect frame = textBanner.frame;
        [UIView animateWithDuration:durationTime
                         animations:^{
                             textBanner.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, -frame.size.height, frame.size.width, frame.size.height);
                         }];
    }
}

@end
