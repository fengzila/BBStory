//
//  BBCycleScrollView.h
//  BB
//
//  Created by FengZi on 13-12-25.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBHomeBannerScrollView;
@protocol BBHomeBannerScrollViewDelegate <NSObject>

@optional
- (void)didClickPage:(BBHomeBannerScrollView *)csView atIndex:(NSInteger)index;
- (void)changePage;
@end

@protocol BBHomeBannerScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end

@interface BBHomeBannerScrollView : UIView<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    id<BBHomeBannerScrollViewDelegate> _delegate;
    id<BBHomeBannerScrollViewDatasource> _datasource;
    
    UIView *_targetView;
    
    NSInteger _totalPages;
    
    NSMutableArray *_curViews;
    NSTimer *_scrollTimer;
    
    int timerCount;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, setter = setDatasource:) id<BBHomeBannerScrollViewDatasource> datasource;
@property (nonatomic, setter = setDelegate:) id<BBHomeBannerScrollViewDelegate> delegate;

- (void)loadData;
- (void)reloadData;
- (void)reloadDataWithoutAnimation;
@end

