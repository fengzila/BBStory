//
//  NSObject+BBBanner.h
//  BBStory
//
//  Created by Fengzi on 15/10/15.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBBanner : NSObject

-(void)requestWithViewController:(UIViewController*)vc;
-(void)showWithAnimationDuration:(CGFloat)durationTime;
-(void)hideWithAnimationDuration:(CGFloat)durationTime;

@end
