//
//  BBCycleScrollView.m
//  BB
//
//  Created by FengZi on 13-12-25.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBHomeBannerScrollView.h"
#import "BBCycleScrollCell.h"

@implementation BBHomeBannerScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        
        [self addSubview:_pageControl];
        
//        _curPage = [self validPageValue:-1];
    }
    return self;
}

- (void)setDatasource:(id<BBHomeBannerScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadDataWithoutAnimation];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    _curPage = _totalPages - 1;
    if (_totalPages == 0)
    {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
    
    [self roll];
}

- (void)reloadDataWithoutAnimation
{
    _totalPages = [_datasource numberOfPages];
    _curPage = 0;
    if (_totalPages == 0)
    {
        return;
    }
    _pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    _pageControl.currentPage = _curPage;
    _scrollView.contentSize = CGSizeMake(self.bounds.size.width * _totalPages, self.bounds.size.height);
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scrollView subviews];
    if([subViews count] != 0)
    {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:(int)_curPage];
    
    for (int i = 0; i < _totalPages; i++)
    {
        UIView *v = [_curViews objectAtIndex:i];
        if (i == 0) {
            v.backgroundColor = [UIColor yellowColor];
        } else if (i == 1) {
            v.backgroundColor = [UIColor blueColor];
        } else {
            v.backgroundColor = [UIColor greenColor];
        }
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i * .5f, 0);
        v.tag = i+1;
        [_scrollView addSubview:v];
    }
    
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    [self.delegate changePage];
}

- (void)getDisplayImagesWithCurpage:(int)page
{
    
    if (!_curViews)
    {
        _curViews = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < _totalPages; i++)
        {
            [_curViews addObject:[_datasource pageAtIndex:i]];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    
    if ([_delegate respondsToSelector:@selector(didClickPage:atIndex:)])
    {
        [_delegate didClickPage:self atIndex:_curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    return;
//    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:YES];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
