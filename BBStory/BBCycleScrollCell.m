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
        
        [self loadSquareBanner];
    }
    return self;
}

-(void)loadSquareBanner
{
    _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, _contentWebView.scrollView.contentSize.height, kDeviceWidth, 0)];
    _bannerView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [_contentWebView.scrollView addSubview:_bannerView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kDeviceWidth, 30)];
    title.text = @"爸比小广告";
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentLeft];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:14];
    [_bannerView addSubview:title];
    
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, kDeviceWidth, 30)];
    info.text = @"点击广告打赏";
    info.backgroundColor = [UIColor clearColor];
    [info setTextAlignment:NSTextAlignmentRight];
    info.textColor = [UIColor blueColor];
    info.font = [UIFont systemFontOfSize:14];
    [_bannerView addSubview:info];
    
    if (kDeviceWidth > 640) {
        _adSquareBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
        _adSquareBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    }
    CGRect frame = _adSquareBannerView.frame;
    _adSquareBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 30, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
    //    _adSquareBannerView.adUnitID = @"ca-app-pub-4220651662523392/8061564860";
    _adSquareBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adSquareBannerView.rootViewController = self;
    [_bannerView addSubview:_adSquareBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adSquareBannerView loadRequest:[GADRequest request]];

}

- (void)resetBannerPosition
{
    NSString *height_str= [_contentWebView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
    int height = [height_str intValue];
    _bannerView.frame = CGRectMake(0, height + 60, kDeviceWidth, 30 + _adSquareBannerView.height + 15);
    _contentWebView.scrollView.contentSize = CGSizeMake(_contentWebView.scrollView.contentSize.width, _contentWebView.scrollView.contentSize.height + _bannerView.frame.size.height+ 80);
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
    
    [self resetBannerPosition];
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
