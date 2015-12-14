//
//  BBStoryRecordTableView.m
//  BBStory
//
//  Created by Fengzi on 15/10/26.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBCategoryTableViewDelegate <NSObject>

- (void)pushInfoVCWithIndex:(int)index;

@end

@interface BBCategoryTableView : UIView<UITableViewDelegate, UITableViewDataSource>
{
@private
    UITableView*_tableView;
    NSMutableArray* _data;
}
@property (nonatomic) id <BBCategoryTableViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame Data:(NSMutableArray*)data;
- (NSInteger)adaptFrameHeight;
@end
