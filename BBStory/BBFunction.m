//
//  BBFunction.m
//  BBClock
//
//  Created by FengZi on 14-1-15.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBFunction.h"

@implementation BBFunction

+ (void)goToAppStoreEvaluate:(int)appId
{
    NSString *strUrl;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        strUrl = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", appId];
    }
    else
    {
        strUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d?at=10l6dK", appId];
    }
    NSURL *url = [NSURL URLWithString:strUrl];
    [[UIApplication sharedApplication] openURL:url];
}
@end
