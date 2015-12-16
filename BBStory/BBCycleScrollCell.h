//
//  BBCycleScrollCell.h
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADBannerView.h>

@class BBMaterialView;
@class BBStepView;

@protocol BBCycleScrollCellDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end
@interface BBCycleScrollCell : UIView<UIScrollViewDelegate, UIWebViewDelegate>
{
@private
    UIScrollView *_baseView;
    UIImageView *_imageView;
    UILabel *_pageIndexLabel;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIWebView *_contentWebView;
    UIView *_bgView;
    NSDictionary *_data;
    GADBannerView *_adSquareBannerView;
    UIView *_bannerView;
}

@property (nonatomic) id <BBCycleScrollCellDelegate> delegate;
- (void)loadData:(NSDictionary*)data;
- (void)goTop;
- (void)setContentFontSize:(int)fontSize;
- (void)setDarkMode:(BOOL)isDarkMode;
@end
