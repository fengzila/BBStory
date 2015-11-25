//
//  UIView+BBStoryInfoView.m
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import "BBTangshiInfoView.h"
#import "BBDataManager.h"

@implementation BBTangshiInfoView
- (id)initWithFrame:(CGRect)frame Container:(UIScrollView*)view
{
    self = [super initWithFrame:frame];
    if (self) {
        _baseView = view;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:18];
        _contentLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_contentLabel];
        
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
    NSString *author = [data objectForKey:@"autor"];
    NSString *yunyi = [data objectForKey:@"yunyi"];
    NSString *zhujie = [data objectForKey:@"zhujie"];
    NSString *pingxi = [data objectForKey:@"pingxi"];
    NSString *contentStr = [data objectForKey:@"content"];
    
    //    _pageIndexLabel.text = [data objectForKey:@"pageIndex"];
    
    NSInteger height = 90;
    if (kDeviceWidth > 640)
    {
        height = 150;
    }
    
    _titleLabel.text = titleStr;
    _titleLabel.frame = CGRectMake(0, height, self.width, 25);
    
    height += _titleLabel.height + 10;
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, height, self.width - 15 * 2, 30)];
    authorLabel.backgroundColor = [UIColor clearColor];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.textColor = [UIColor blackColor];
    authorLabel.font = [UIFont systemFontOfSize:18];
    authorLabel.text = author;
    [self addSubview:authorLabel];
    
    height += authorLabel.height + 10;
    
    //设置一个行高上限
    CGSize size = CGSizeMake(self.width, 3000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:19] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    _contentLabel.text = contentStr;
    [_contentLabel setFrame:CGRectMake(0, height, self.width, labelSize.height)];
    
    height += _contentLabel.height + 30;
    
    UILabel *zhujieTitleLabel = [self createSingleLineLabel:@"注解：" Height:height];
    
    height += zhujieTitleLabel.height + 5;
    
    UILabel *zhujieLabel = [self createMultiLinesLabel:zhujie Height:height];
    
    height += zhujieLabel.height + 20;
    
    UILabel *yunyiTitleLabel = [self createSingleLineLabel:@"韵译：" Height:height];
    
    height += yunyiTitleLabel.height + 5;
    
    UILabel *yunyiLabel = [self createMultiLinesLabel:yunyi Height:height];
    
    height += yunyiLabel.height + 20;
    
    UILabel *pingxiTitleLabel = [self createSingleLineLabel:@"评析：" Height:height];
    
    height += pingxiTitleLabel.height + 5;
    
    UILabel *pingxiLabel = [self createMultiLinesLabel:pingxi Height:height];
    
    height += pingxiLabel.height;
    
    height += 100;
    
    if (height < kDeviceHeight) {
        height = kDeviceHeight + 10;
    }
    
    [self setColorTheme];
    
    self.frame = CGRectMake(5, 0, self.width - 5*2, height);
    
    return (int)height;
}

- (UILabel*)titleLabelWithStr:(NSString*)str
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = str;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    return titleLabel;
}

- (UILabel*)createSingleLineLabel:(NSString*)str Height:(int)height
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, height, self.width - 15 * 2, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = str;
    [self addSubview:label];
    
    return label;
}

- (UILabel*)createMultiLinesLabel:(NSString*)str Height:(int)height
{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    label.adjustsFontSizeToFitWidth = YES;
    
    //设置一个行高上限
    CGSize size = CGSizeMake(self.width, 3000);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    label.text = str;
    [label setFrame:CGRectMake(15, height, self.width - 15 * 2, labelSize.height)];
    [self addSubview:label];
    
    return label;
}

- (void)setColorTheme
{
    int index = [[BBDataManager getInstance] getColorIndex] % [_colorTheme count];
    _baseView.backgroundColor = [[_colorTheme objectAtIndex:index] objectForKey:@"containerColor"];
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
@end
