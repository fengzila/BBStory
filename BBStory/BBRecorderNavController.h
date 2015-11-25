//
//  UINavigationController+BBMainNavController.h
//  BBStory
//
//  Created by Fengzi on 15/6/9.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"

@interface BBRecorderNavController : UINavigationController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
