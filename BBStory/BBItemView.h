//
//  BBItemView.h
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BBItemView;
@protocol BBItemViewDelegate <NSObject>

@optional
- (void)touchItemView:(BBItemView *)itemView atIndex:(NSInteger)index;

@end

@interface BBItemView : UIView
{
@private
    UIImageView *_item;
    UILabel *_title;
    id <BBItemViewDelegate> _delegate;
    
    BOOL _withText;
}

@property (nonatomic, readonly) UIImageView *item;
@property (nonatomic, readonly) UIImageView *selectItem;
@property (nonatomic, readonly) UILabel *title;
@property id <BBItemViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame WithText:(BOOL)text;

@end
