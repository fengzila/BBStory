
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ICSDrawerController.h"

@interface BBDoRecordingView : UIView<UIWebViewDelegate, AVAudioRecorderDelegate>
{
@private
    NSDictionary* _data;
    UIView *_bgView;
    UIView *_tabbarView;
    UIView *_topbarView;
    UIImageView *_tabbarLine;
    UIImageView *_controlLine;
    UIButton *_recordingBtn;
    BOOL _isRecording;
    UILabel *_volumeTips;
    UIButton *_bgMusicBtn0;
    UIButton *_bgMusicBtn1;
    UIButton *_bgMusicBtn2;
    UIButton *_bgMusicBtn3;
    UIWebView *_contentWebView;
    UILabel *_recordTimeTips;
    AVAudioPlayer *_avAudioPlayer;
    AVAudioRecorder *_recorder;
    NSDictionary *_recorderSettingsDict;
    //录音名字
    NSString *_recorderName;
    NSString *_saveKey;
    //定时器
    NSTimer *timer;
    CGFloat _recorderDuration;
}

@property(nonatomic, weak) ICSDrawerController *drawer;

- (id)initWithFrame:(CGRect)frame Data:(NSDictionary*)data;
-(void)showWithAnimation;
@end
