//
//  BBCycleScrollCell.h
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBUserScrollViewDelegate <NSObject>

- (void)pushInfoVC:(UIViewController *)viewController;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface BBUserScrollView : UIView<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
@private
    UIScrollView *_baseView;
    UIImageView *_imageView;
    NSMutableArray *_data;
    UITableView *_tableView;
}

@property (nonatomic) id <BBUserScrollViewDelegate> delegate;
@end
