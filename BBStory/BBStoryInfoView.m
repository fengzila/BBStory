//
//  UIView+BBStoryInfoView.m
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import "BBStoryInfoView.h"
#import "BBDataManager.h"

@implementation BBStoryInfoView
- (id)initWithFrame:(CGRect)frame Container:(UIScrollView*)view
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontSize = 18.0f;
        _baseView = view;
//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
//        [self addSubview:_titleLabel];
//        
//        _contentLabel = [[UILabel alloc] init];
//        _contentLabel.textColor = [UIColor blackColor];
//        _contentLabel.backgroundColor = [UIColor clearColor];
//        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _contentLabel.numberOfLines = 0;
//        _contentLabel.font = [UIFont systemFontOfSize:18];
//        _contentLabel.adjustsFontSizeToFitWidth = YES;
//        [self addSubview:_contentLabel];
        
//        _titleLabel = [[UITextView alloc] init];
//        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.textColor = [UIColor blackColor];
//        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
//        [self addSubview:_titleLabel];
        
//        _contentLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.width - 10, self.frame.size.height)];
//        _contentLabel = [[UITextView alloc] init];
//        _contentLabel.editable = NO;
//        _contentLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [self addSubview:_contentLabel];
        
        UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width*.5 - 155*.5, 0, 155, 155)];
        logoView.image = [UIImage imageNamed:@"logo"];
        [self addSubview:logoView];
        
        _contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height - 50)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.opaque = NO;
        _contentView.delegate = self;
        [self addSubview:_contentView];
        // 关闭webview滑动
//        _contentView.scrollView.scrollEnabled = false;
        _contentView.scrollView.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTap)];
        tap.numberOfTapsRequired = 2; // 双击
        [self addGestureRecognizer:tap];
        
        _tapNum = 0;
        _colorTheme = [[NSArray alloc] initWithObjects:
                       [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor whiteColor], @"bgColor", [UIColor blackColor], @"fontColor", [UIColor whiteColor], @"containerColor", nil],
                       [[NSDictionary alloc] initWithObjectsAndKeys:[UIColor blackColor], @"bgColor", [UIColor grayColor], @"fontColor", [UIColor blackColor], @"containerColor", nil],
                       nil];
    }
    return self;
}

- (int)loadData:(NSDictionary*)data
{
    NSString *titleStr = [data objectForKey:@"title"];
    NSString *contentStr = [data objectForKey:@"content"];
    
//    _pageIndexLabel.text = [data objectForKey:@"pageIndex"];
    
    NSInteger height = 90;
    if (kDeviceWidth > 640)
    {
        height = 150;
    }
    
//    _titleLabel.text = titleStr;
//    _titleLabel.frame = CGRectMake(0, height, self.width, 25);
//    
//    height += _titleLabel.height;
//    
//    NSString *contentStrFormat = [NSString stringWithFormat:@"    %@", contentStr];
//    
//    //设置一个行高上限
//    CGSize size = CGSizeMake(self.width, 2000);
//    //计算实际frame大小，并将label的frame变成实际大小
//    CGSize labelSize = [contentStrFormat sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
//    _contentLabel.text = contentStrFormat;
//    [_contentLabel setFrame:CGRectMake(15, height, self.width - 28, labelSize.height)];
    
//    _contentLabel.text = contentStrFormat;
//    _contentLabel.font = [UIFont systemFontOfSize:_fontSize];
//    [_contentLabel setFrame:CGRectMake(15, height, self.width - 16, self.height)];
    
    NSString *contentStrFormat = [NSString stringWithFormat:@"    <html><body style=\"font-size:16px;\">%@</body></html>", contentStr];
    [_contentView loadHTMLString:contentStrFormat baseURL:nil];
    int height1 = [[_contentView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] intValue];
    NSLog(@"pre webview scroll height is %d,kDeviceHeight is %d", height1, (int)kDeviceHeight);
    
    [self setColorTheme];
    
    return (int)height;
}

- (void)setColorTheme
{
    int index = [[BBDataManager getInstance] getColorIndex] % [_colorTheme count];
    _baseView.backgroundColor = [[_colorTheme objectAtIndex:index] objectForKey:@"containerColor"];
    _baseView.backgroundColor = [UIColor redColor];
    self.backgroundColor = [[_colorTheme objectAtIndex:index] objectForKey:@"bgColor"];
    
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UILabel class]]) {
            UILabel* label = (UILabel*)obj;
            label.textColor = [[_colorTheme objectAtIndex:index] objectForKey:@"fontColor"];
        }
    }
}

- (void)DoubleTap
{
    [[BBDataManager getInstance] changeColor];
    [self setColorTheme];
}

- (void)setContentFontSize:(int)fontSize
{
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '60%'";
    [_contentView stringByEvaluatingJavaScriptFromString:str];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    CGFloat height = [[_contentView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//    NSLog(@"webview scroll height is %f,kDeviceHeight is %d", height, (int)kDeviceHeight);
//    
//    _contentView.frame = CGRectMake(_contentView.frame.origin.x, _contentView.frame.origin.y, self.width, height);
//    _baseView.contentSize = CGSizeMake(_baseView.bounds.size.width, height);
//    
//    height += 50;
//    
//    if (height < kDeviceHeight) {
//        height = kDeviceHeight + 10;
//    }
//    
//    self.frame = CGRectMake(0, 0, self.width, height);
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = _baseView.contentOffset.y;
    
//    CGFloat ImageWidth  = self.width - 20;
//    CGFloat ImageHeight  = (self.width - 20)*3/5 - 3;
//    if (yOffset < 0)
//    {
//        CGFloat factor = ((ABS(yOffset)+ImageHeight)*ImageWidth)/ImageHeight;
//        CGRect f = CGRectMake(-(factor-ImageWidth)/2 + 10, 10, factor, ImageHeight+ABS(yOffset));
//        _imageView.frame = f;
//    }
//    else
//    {
//        CGRect f = _imageView.frame;
//        f.origin.y = -yOffset + 10;
//        _imageView.frame = f;
//    }
//    
//    [self.delegate scrollViewDidScroll:scrollView];
}
@end
