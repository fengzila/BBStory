//
//  BBMainViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBRecordCategoryListController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView *_tableView;
}

@end
