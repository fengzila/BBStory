//
//  BBCycleViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCycleScrollView.h"
#import "BBCycleScrollCell.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "BBInfoSettingView.h"
#import "BBDoRecordingView.h"

@interface BBDoRecordingController : UIViewController<UIWebViewDelegate, AVAudioRecorderDelegate>
{
@private
    NSDictionary* _data;
    NSDictionary* _configData;
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
- (id)initWithData:(NSDictionary*)data ConfigData:(NSDictionary*)configData;
@end
