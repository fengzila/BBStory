//
//  BTPlatform.h
//  BaiTongSDK
//
//  Created by WangJianHui on 14-11-17.
//  Copyright (c) 2014年 91. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BTSDK_VERSION @"2.1"
#define IS_SHOW_AD_NOTIFICATION_NAME  @"isShowAdNotification"
#define IS_SHOW_WALL @"isShowWall"
#define IS_SHOW_BANNER @"isShowBanner"
#define IS_SHOW_SCREEN @"isShowScreen"

@interface BTPlatform : NSObject

/**
 @brief  初始化单例
*/
+ (BTPlatform *)sharedInstance;

/**
 @brief 设置应用appkey并得到广告开启状态
 @param key 应用程序appkey，需要向开发者后台申请
 @param isAvailable 应用的广告状态是否可用
*/

- (void)setAppKey:(NSString *)key result:(void(^)(BOOL isAvailable))block;

/**
 @brief  显示广告墙
*/
- (void)showWall;

/**
 @brief  创建图片Banner
 @result 返回一个Banner视图
*/

- (UIView *)pictureBannerWithPosition:(CGPoint)origin;

/**
 @brief  创建图文Banner
 @result 返回一个Banner视图
 */

- (UIView *)textBannerWithPosition:(CGPoint)origin;

/**
 @brief  创建插屏广告
 @result 返回一个插屏广告视图
 */

- (void)showInsertScreen;

/**
 @brief  设置是否开启开启Log
 @b      是否开启Log
*/
- (void)logEnable:(BOOL)boolean;

@end


