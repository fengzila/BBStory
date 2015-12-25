//
//  PlayViewController.h
//  AndersenStory
//
//  Created by LiuYanghui on 15/6/9.
//  Copyright (c) 2015年 LiuYanghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRecorderObject.h"
#import "ICSDrawerController.h"

@interface PlayViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting>
{
@private
    int _index;
    NSDictionary* _configData;
    NSArray* _data;
    NSString *_musicKey;
    UILabel *_pageLabel;
}

@property(nonatomic, weak) ICSDrawerController *drawer;
- (id)initWithIndex:(int)index ConfigData:(NSDictionary*)configData;
- (void)playNewSound;
- (void)pause;

@end

