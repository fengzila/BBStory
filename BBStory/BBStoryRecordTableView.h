//
//  BBStoryRecordTableView.m
//  BBStory
//
//  Created by Fengzi on 15/10/26.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBRecorderObject.h"

@protocol BBStoryRecordTableViewDelegate <NSObject>

- (void)pushInfoVCWithData:(BBRecorderObject*)data index:(int)index;

@end

@interface BBStoryRecordTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView*_tableView;
    NSMutableArray* _data;
    NSString *_recorderListKey;
}
@property (nonatomic) id <BBStoryRecordTableViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Data:(NSMutableArray*)data;
@end
