
#import <UIKit/UIKit.h>

@protocol BBInfoSettingViewDelegate <NSObject>

- (void)removeInfoSettingViewCallback;
- (void)setContentFontSize:(int)fontSize;
- (void)setDarkMode:(BOOL)isDarkMode;

@end

@interface BBInfoSettingView : UIView
{
@private
    UIView *_bgView;
    UIView *_containerView;
    UISwitch *_darkModeSwitchView;
    UISegmentedControl *_segmentedControl;
    UIButton *_completeBtn;
    UIImageView *_line1;
    UIImageView *_line2;
    UIImageView *_line3;
}
@property (nonatomic) id <BBInfoSettingViewDelegate> delegate;
@property (nonatomic) NSString* dueDate;

- (void)showWithAnimation;
- (void)hiddenWithAnimation;
@end
