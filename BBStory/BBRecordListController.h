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

@interface BBRecordListController : UIViewController<BBStoryRecordTableViewDelegate>
{
@private
    NSData* _data;
    NSString* _title;
}

- (id)initWithData:(NSData*)data Title:(NSString*)title;

@end
