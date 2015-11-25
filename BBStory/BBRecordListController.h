//
//  BBMainViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICSDrawerController.h"
#import "BBStoryRecordTableView.h"
#import "BBRecorderObject.h"

@interface BBRecordListController : UIViewController<UINavigationControllerDelegate, ICSDrawerControllerChild, ICSDrawerControllerPresenting, BBStoryRecordTableViewDelegate>
{
@private
    BBStoryRecordTableView *_storyView;
    BBStoryRecordTableView *_tangshiView;
    
    UISegmentedControl *_segControl;
    
    BOOL _tabbarIsHidden;
    
    NSArray *_segTitleArr;
    
    int _statusBarHeight;
}

@property(nonatomic, weak) ICSDrawerController *drawer;

@end
