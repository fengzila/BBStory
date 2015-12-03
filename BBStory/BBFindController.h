//
//  BBMainViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBStoryRecordTableView.h"
#import "BBRecorderObject.h"

@interface BBFindController : UIViewController<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
@private
    
    NSArray *_menuArr;
    NSArray *_menuImgArr;
    UITableView* _tableView;
    BOOL _tabbarIsHidden;
    int _statusBarHeight;
}

@end
