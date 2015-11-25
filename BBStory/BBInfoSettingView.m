//
//  BBDueDatePickerView.m
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBInfoSettingView.h"
#import "BBDataManager.h"

@implementation BBInfoSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor clearColor];

        [self addSubview:_bgView];
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, 150)];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containerView];
        
        _line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 1)];
        _line1.image = [UIImage imageNamed:@"btn_bg"];
        [_containerView addSubview:_line1];
        
        _line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, kDeviceWidth, 1)];
        _line2.image = [UIImage imageNamed:@"btn_bg"];
        [_containerView addSubview:_line2];
        
        _line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, kDeviceWidth, 1)];
        _line3.image = [UIImage imageNamed:@"btn_bg"];
        [_containerView addSubview:_line3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWithAnimation)];
        [_bgView addGestureRecognizer:tap];
        
        UILabel *darkModeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50*.5 - 30*.5, _containerView.width - 40, 30)];
        darkModeTitleLabel.text = @"夜间模式";
        darkModeTitleLabel.backgroundColor = [UIColor clearColor];
        darkModeTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        darkModeTitleLabel.numberOfLines = 0;
        darkModeTitleLabel.font = [UIFont systemFontOfSize:14];
        [_containerView addSubview:darkModeTitleLabel];
        
        _darkModeSwitchView = [[UISwitch alloc] initWithFrame:CGRectMake(_containerView.width - 100*.5 - 20, 50*.5 - 28.0f*.5, 100.0f, 28.0f)];
        _darkModeSwitchView.on = [[BBDataManager getInstance] isDarkMode];
        [_darkModeSwitchView addTarget:self action:@selector(darkModeSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [_containerView addSubview:_darkModeSwitchView];
        
        UILabel *fontTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 50*1.5 - 30*.5, _containerView.width - 40, 30)];
        fontTitleLabel.text = @"字体大小";
        fontTitleLabel.backgroundColor = [UIColor clearColor];
        fontTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        fontTitleLabel.numberOfLines = 0;
        fontTitleLabel.font = [UIFont systemFontOfSize:14];
        [_containerView addSubview:fontTitleLabel];
        
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"小", @"中", @"大", @"超大"]];
        [_segmentedControl setFrame:CGRectMake(_containerView.width - 150 - 20, 50*1.5 - 30*.5, 150, 30)];
        
        int fontSize = [[BBDataManager getInstance] getContentFontSize];
        switch (fontSize) {
            case 80:
                _segmentedControl.selectedSegmentIndex = 0;
                break;
            case 100:
                _segmentedControl.selectedSegmentIndex = 1;
                break;
            case 120:
                _segmentedControl.selectedSegmentIndex = 2;
                break;
            case 140:
                _segmentedControl.selectedSegmentIndex = 3;
                break;
                
            default:
                break;
        }
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
        [_segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged];
        [_containerView addSubview:_segmentedControl];
        
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        [_completeBtn setFrame:CGRectMake(0, _containerView.height - 44, _containerView.width, 44)];
        [_completeBtn addTarget:self action:@selector(completeBtnAction) forControlEvents:UIControlEventTouchDown];
        [_containerView addSubview:_completeBtn];
        
        [self setDarkMode:[[BBDataManager getInstance] isDarkMode]];
    }
    return self;
}

- (void)showWithAnimation
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         _bgView.backgroundColor = [UIColor blackColor];
                         _bgView.alpha = 0.4f;
                         _containerView.frame = CGRectMake(0, kDeviceHeight - _containerView.height, kDeviceWidth, _containerView.height);
                     }];
}

- (void)hiddenWithAnimation
{
    _bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.4
                     animations:^{
                         _containerView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, _containerView.height);
                         [self.delegate removeInfoSettingViewCallback];
                     }];
}

- (void)segmentAction:(UISegmentedControl*)sender
{
    NSLog(@"segmentAction------%d", (int)sender.selectedSegmentIndex);
    int fontSize;
    switch (sender.selectedSegmentIndex) {
        case 0:
            fontSize = 80;
            break;
        case 1:
            fontSize = 100;
            break;
        case 2:
            fontSize = 120;
            break;
        case 3:
            fontSize = 140;
            break;
            
        default:
            fontSize = 100;
            break;
    }
    [[BBDataManager getInstance] setContentFontSize:fontSize];
    [self.delegate setContentFontSize:fontSize];
}

- (void)completeBtnAction
{
//    [self.delegate datePickerSelectValue:destDateString];
    [self hiddenWithAnimation];
}

- (void)darkModeSwitchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [[BBDataManager getInstance] setIsDarkMode:isButtonOn];
    [self.delegate setDarkMode:isButtonOn];
    [self setDarkMode:isButtonOn];
}

-(void)setDarkMode:(BOOL)isDarkMode
{
    if (isDarkMode) {
        _containerView.backgroundColor = [UIColor colorWithRed:24/255.0 green:25/255.0 blue:26/255.0 alpha:1];
        _darkModeSwitchView.onTintColor= [UIColor colorWithRed:69/255.0 green:152/255.0 blue:230/255.0 alpha:1];
        
        [_line1 setAlpha:.12];
        [_line2 setAlpha:.12];
        [_line3 setAlpha:.12];
        
        for (id obj in _containerView.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)obj;
                label.textColor = [UIColor grayColor];
            }
        }
        
        NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:69/255.0 green:152/255.0 blue:230/255.0 alpha:1],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
        NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:32/255.0 green:52/255.0 blue:73/255.0 alpha:1],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
        [_segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
        
        _segmentedControl.tintColor = [UIColor colorWithRed:69/255.0 green:152/255.0 blue:230/255.0 alpha:1];
        [_completeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } else {
        _containerView.backgroundColor = [UIColor whiteColor];
        _darkModeSwitchView.onTintColor=[UIColor greenColor];
        
        [_line1 setAlpha:1];
        [_line2 setAlpha:1];
        [_line3 setAlpha:1];
        
        for (id obj in _containerView.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                UILabel* label = (UILabel*)obj;
                label.textColor = [UIColor blackColor];
            }
        }
        
        NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:247/255.0 green:45/255.0 blue:55/255.0 alpha:1],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
        NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
        [_segmentedControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
        
        _segmentedControl.tintColor = [UIColor colorWithRed:243/255.0 green:76/255.0 blue:51/255.0 alpha:1];
        [_completeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
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
