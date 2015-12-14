//
//  BBCycleScrollCell.m
//  BB
//
//  Created by FengZi on 14-1-18.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBCycleScrollCell.h"
#import "BBDataManager.h"
#import "MobClick.h"

@implementation BBCycleScrollCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
        view.backgroundColor = [UIColor clearColor];
        
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height)];
        _contentWebView.scalesPageToFit = NO;
        _contentWebView.backgroundColor = [UIColor clearColor];
        _contentWebView.opaque = NO;
        _contentWebView.delegate = self;
        [self addSubview:_contentWebView];
        _contentWebView.scrollView.delegate = self;
        
        [self setDarkModeOther:[[BBDataManager getInstance] isDarkMode]];
    }
    return self;
}

- (void)loadData:(NSDictionary*)data
{
    _data = data;
    [self refresh];
    
    [MobClick event:@"read" attributes:@{@"recorderId" : [NSString stringWithFormat:@"%@", [_data objectForKey:@"id"]], @"name" : [_data objectForKey:@"title"]}];
}

- (void)refresh
{
    NSString *contentStr = [_data objectForKey:@"content"];
    
    NSString *contentStrFormat = [NSString stringWithFormat:@"    <html><body style=\"font-size:16px;\">%@</body></html>", contentStr];
    [_contentWebView loadHTMLString:contentStrFormat baseURL:nil];
}

- (void)setContentFontSize:(int)fontSize
{
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [_contentWebView stringByEvaluatingJavaScriptFromString:str];
}

- (void)setDarkModeOther:(BOOL)isDarkMode
{
    if (isDarkMode) {
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
//        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.backgroundColor='#111111'"];
        _contentWebView.scrollView.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1];
    } else {
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
//        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.backgroundColor='#ffffff'"];
        _contentWebView.scrollView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setDarkMode:(BOOL)isDarkMode
{
//    [self refresh];
    [self setDarkModeOther:isDarkMode];
}

- (void)goTop
{
    [_baseView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    [self.delegate scrollViewDidEndDecelerating:scrollView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setContentFontSize:[[BBDataManager getInstance] getContentFontSize]];
    [self setDarkModeOther:[[BBDataManager getInstance] isDarkMode]];
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
