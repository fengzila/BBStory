//
//  BBItemView.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBItemView.h"

@implementation BBItemView

- (id)initWithFrame:(CGRect)frame WithText:(BOOL)text
{
    self = [super initWithFrame:frame];
    if (self) {
        _withText = text;
        
        [self initSubViews];
        
        [self addGesture];
    }
    return self;
}

- (void)initSubViews
{
    _item = [[UIImageView alloc] initWithFrame:CGRectMake(self.width/2.0 - 29 / 2, 3, 29, 29)];
    _item.contentMode = UIViewContentModeScaleAspectFill;
    _item.userInteractionEnabled = YES;
    [self addSubview:_item];
    
    if (_withText) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, _item.bottom + 5, self.width, 10)];
        _title.backgroundColor = [UIColor clearColor];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont boldSystemFontOfSize:12];
        [self addSubview:_title];
    }
    else
    {
        _item.frame = CGRectMake(self.width/2.0 - 35 / 2, 3, 35, 40);
    }
}

- (void)addGesture
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchItemView:)];
    [self addGestureRecognizer:tap];
}

- (void)touchItemView:(UITapGestureRecognizer *)tap
{
    [self.delegate touchItemView:self atIndex:self.tag];
    NSLog(@"self tag is %d", self.tag);
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
