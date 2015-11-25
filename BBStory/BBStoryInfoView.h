//
//  UIView+BBStoryInfoView.h
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBStoryInfoView : UIView<UIWebViewDelegate, UIScrollViewDelegate>
{
@private
    UIScrollView *_baseView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
//    UITextView *_titleLabel;
//    UITextView *_contentLabel;
    UIWebView *_contentView;
    CGFloat _fontSize;
    
    NSArray *_colorTheme;
    int _tapNum;
}
- (id)initWithFrame:(CGRect)frame Container:(UIScrollView*)view;
- (int)loadData:(NSDictionary*)data;
- (void)setContentFontSize:(int)fontSize;
@end
