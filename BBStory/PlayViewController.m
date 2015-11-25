//
//  PlayViewController.m
//  AndersenStory
//
//  Created by LiuYanghui on 15/6/9.
//  Copyright (c) 2015年 LiuYanghui. All rights reserved.
//

#import "PlayViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <AVFoundation/AVFoundation.h>
#import "BBBannerManager.h"
#import "BBDataManager.h"
#import "MobClick.h"

#define degressToRadian(x) (M_PI * (x)/180.0)
#define ADViewHeight 0

@interface PlayViewController () <AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;        // 播放器
@property (nonatomic, strong) UILabel *musicTitle;            // title
@property (nonatomic, strong) UILabel *progressTitle;
@property (nonatomic, strong) UILabel *progressMaxTitle;
@property (nonatomic, strong) UIProgressView *progressV; // 播放进度
@property (nonatomic, strong) UISlider *volumeSlider;    // 声音控制
@property (nonatomic, strong) UIImageView *musicImageView;   // 封面
@property (nonatomic, strong) NSTimer *timer;            // 监控音频播放进度
@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) UIButton *btnLoveMusic;

@end

@implementation PlayViewController

- (id)initWithIndex:(int)index
{
    self = [super init];
    if (self) {
        _index = index;
        NSString *recorderListKey;
        switch ([[BBDataManager getInstance] getCurContentDataType]) {
            case kContentDataTypeStory:
                recorderListKey = UD_RECORDER_STORY_LIST;
                _musicKey = @"story";
                break;
            case kContentDataTypeTangshi:
                recorderListKey = UD_RECORDER_TANGSHI_LIST;
                _musicKey = @"tangshi";
                break;
                
            default:
                break;
        }
        NSData* data  = [[NSUserDefaults standardUserDefaults] objectForKey:recorderListKey];
        _data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawer.DisEnableTouchMove = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:229/255.0
                                                green:229/255.0
                                                 blue:229/255.0
                                                alpha:1
                                 ];
    
    [self initTopMusicImage];
    
    [self initMusicProgressBar];

    [self initControBtns];
    
    [self initBottomBar];
    
    [self updatePlayerSetting];
    
    [[BBBannerManager getInstance] requestWithViewController:self];
    [[BBBannerManager getInstance] showWithAnimationDuration:0.1f];
    
    // 用NSTimer来监控音频播放进度
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                            selector:@selector(playProgress)
                                            userInfo:nil repeats:YES];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [self play];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        BBRecorderObject *data = [_data objectAtIndex:_index];
        NSString *title = data.name;
        NSNumber *duration = [NSNumber numberWithInt:_avAudioPlayer.duration];
        NSNumber *currentTime = [NSNumber numberWithInt:_avAudioPlayer.currentTime];
        
        UIImage *image = [UIImage imageNamed:@"Icon_big"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        
        NSDictionary *nowPlaying = @{MPMediaItemPropertyTitle:title,
                                     MPMediaItemPropertyAlbumTitle:@"爸比讲故事",
                                     MPMediaItemPropertyPlaybackDuration:duration,
                                     MPNowPlayingInfoPropertyElapsedPlaybackTime:currentTime,
                                     MPMediaItemPropertyArtwork:artwork
                                     };
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlaying];
        
    }
    
}

- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [self pause];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self lastMusicAction:nil];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [self nextMusicAction:nil];
                break;
                
            default:
                break;  
        }  
    }  
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)initTopMusicImage
{
    CGSize screenSize = self.view.frame.size;
    // 封面图
    UIImage *diskImage = [UIImage imageNamed:@"pan.png"];
    
    _musicImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, diskImage.size.width * .51, diskImage.size.height * .51)];
    _musicImageView.center = CGPointMake(screenSize.width * 0.5, (screenSize.height - 138) / 2);
    [_musicImageView setImage:[UIImage imageNamed:@"Icon_big.png"]];
    [self.view addSubview:_musicImageView];
    
    UIImageView *diskBg =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, diskImage.size.width * 1.2, diskImage.size.height * 1.2)];
    diskBg.center = CGPointMake(screenSize.width * 0.5, (screenSize.height - 147) / 2);
    [diskBg setImage:diskImage];
    [self.view addSubview:diskBg];
    
    // 光盘指针
//    UIImage *pointImage = [UIImage imageNamed:@"point.png"];
//    UIImageView *diskPoint =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, pointImage.size.width, pointImage.size.height)];
//    diskPoint.center = CGPointMake(diskBg.center.x + 60, diskBg.center.y + 80);
//    [diskPoint setImage:pointImage];
//    [self.view addSubview:diskPoint];
}

- (void)initMusicProgressBar
{
    CGSize screenSize = self.view.frame.size;
    
    // 初始化一个播放进度条
    _progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(0, screenSize.height - 120, screenSize.width, 20)];
    [_progressV setProgressTintColor:[UIColor colorWithRed:249.0f/255.0f green:63.0f/255.0f blue:30.0f/255.0f alpha:1.0f]];
    [_progressV setProgressViewStyle:UIProgressViewStyleBar];
    [_progressV setBackgroundColor:[UIColor colorWithRed:114/255.0f green:114/255.0f blue:114/255.0f alpha:114/255.0f]];
    [self.view addSubview:_progressV];
    
    _progressMaxTitle = [[UILabel alloc] initWithFrame:CGRectMake(screenSize.width - 110, screenSize.height - 120 - 20, 100, 20)];
    _progressMaxTitle.textAlignment = NSTextAlignmentRight;
    _progressMaxTitle.text = @"00:00";
    _progressMaxTitle.font = [UIFont systemFontOfSize:14];
    _progressMaxTitle.textColor = [UIColor grayColor];
    [self.view addSubview:_progressMaxTitle];
    
    _progressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, screenSize.height - 120 - 20, 100, 20)];
    _progressTitle.textAlignment = NSTextAlignmentLeft;
    _progressTitle.text = @"00:00";
    _progressTitle.font = [UIFont systemFontOfSize:14];
    _progressTitle.textColor = [UIColor grayColor];
    [self.view addSubview:_progressTitle];
    
    _musicTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, screenSize.height - 120 - 50 - 30, screenSize.width, 30.0)];
    _musicTitle.textAlignment = NSTextAlignmentCenter;
    _musicTitle.text = @"";
    _musicTitle.font = [UIFont boldSystemFontOfSize:24];
    _musicTitle.textColor = [UIColor blackColor];
    [self.view addSubview:_musicTitle];
}

- (void)initControBtns
{
    CGSize screenSize = self.view.frame.size;
    
    int paddingBottom = 80;
    // 上一首
    UIImage *btnBackImage = [UIImage imageNamed:@"toolbar_prev_n_p"];
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnBackImage.size.width, btnBackImage.size.height)];
    btnBack.center = CGPointMake(screenSize.width * .5 - 59, screenSize.height - paddingBottom);
    [btnBack setBackgroundImage:btnBackImage forState:UIControlStateNormal];
    [self.view addSubview:btnBack];
    [btnBack addTarget:self action:@selector(lastMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 下一首
    UIImage *btnNextImage = [UIImage imageNamed:@"toolbar_next_n_p"];
    UIButton *btnNext = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnNextImage.size.width, btnNextImage.size.height)];
    btnNext.center = CGPointMake(screenSize.width * .5 + 59, screenSize.height - paddingBottom);
    [btnNext setBackgroundImage:btnNextImage forState:UIControlStateNormal];
    [self.view addSubview:btnNext];
    [btnNext addTarget:self action:@selector(nextMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnPlayBgImage = [UIImage imageNamed:@"toolbar_loading_n_p"];
    UIImageView *btnPlayBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btnPlayBgImage.size.width, btnPlayBgImage.size.height)];
    btnPlayBg.center = CGPointMake(screenSize.width * .5, screenSize.height - paddingBottom);
    btnPlayBg.image = btnPlayBgImage;
    [self.view addSubview:btnPlayBg];
    // 播放
    UIImage *btnPlayImage = [UIImage imageNamed:@"toolbar_play_n_p"];
    _btnPlay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnPlayImage.size.width, btnPlayImage.size.height)];
    self.btnPlay.center = CGPointMake(screenSize.width * .5, screenSize.height - paddingBottom);
    [self.btnPlay setBackgroundImage:btnPlayImage forState:UIControlStateNormal];
    [self.view addSubview:self.btnPlay];
    self.btnPlay.tag = 0;
    [self.btnPlay addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initBottomBar
{
    UIView *tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tabbarView];
    
    UIImageView *tabbarLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, kDeviceWidth, 2)];
    tabbarLine.image = [UIImage imageNamed:@"btn_bg"];
    [tabbarView addSubview:tabbarLine];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(20, tabbarView.height*.5 - 32*.5, 32, 32)];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [tabbarView addSubview:backBtn];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, tabbarView.height)];
    _pageLabel.font = [UIFont boldSystemFontOfSize:16];
    _pageLabel.textColor = [UIColor colorWithRed:113.0f/255.0f green:113.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textAlignment = NSTextAlignmentLeft;
    [tabbarView addSubview:_pageLabel];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
    self.drawer.DisEnableTouchMove = NO;
    [_timer invalidate];
    _avAudioPlayer = nil;
}

- (void)updatePlayerSetting
{

    if (_avAudioPlayer && _avAudioPlayer.playing == YES) {
        [self stop];
    }
    
    //更新曲目
    // 从budle路径下读取音频文件　　轻音乐 - 萨克斯回家 这个文件名是你的歌曲名字,mp3是你的音频格式
    
    BBRecorderObject *data = [_data objectAtIndex:_index];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *string = [NSString stringWithFormat:@"%@/%@_%@.caf", docDir,_musicKey, data.recorderId];
    
    // 把音频文件转换成url格式
    NSURL *url = [NSURL fileURLWithPath:string];
    // 初始化音频类 并且添加播放文件
    NSError* err = nil;
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    if(err){
        NSLog(@"kkkkk====%@", [err description]);
    }
    // 设置代理
    _avAudioPlayer.delegate = self;
    
    // 设置初始音量大小
     _avAudioPlayer.volume = 0.5;
    
    // 设置音乐播放次数  -1为一直循环
    _avAudioPlayer.numberOfLoops = 0;
    
    // 预播放
    [_avAudioPlayer prepareToPlay];
    
    _musicTitle.text = data.name;
    
    _pageLabel.text = [NSString stringWithFormat:@"%d/%d", (int)[_data count] - _index, (int)[_data count]];
}

// 播放
- (void)playAction:(UIButton *)sender
{
    if(self.btnPlay.tag == 1){
        [self pause];
    }else{
        [self play];
    }
    
}

- (void)playNewSound
{
    [self updatePlayerSetting];
    [self play];
}

- (void)play
{
    self.btnPlay.tag = 1;
    [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"toolbar_pause_n_p"] forState:UIControlStateNormal];
    
    [_avAudioPlayer play];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2];
    rotationAnimation.duration = 4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.repeatCount = MAXFLOAT;
    [_musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self configNowPlayingInfoCenter];
    
    BBRecorderObject *data = [_data objectAtIndex:_index];
    [MobClick event:@"playRecorder" attributes:@{@"recorderId" : data.recorderId, @"name" : data.name}];
}

// 暂停
- (void)pause
{
    self.btnPlay.tag = 0;
    [self.btnPlay setBackgroundImage:[UIImage imageNamed:@"toolbar_play_n_p"] forState:UIControlStateNormal];
    
    [_avAudioPlayer pause];
    [_musicImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

// 停止
- (void)stop
{
    _avAudioPlayer.currentTime = 0;  //当前播放时间设置为0
    [_avAudioPlayer stop];
    [_musicImageView.layer removeAnimationForKey:@"rotationAnimation"];
}

// 上一首
- (void)lastMusicAction:(id)sender
{
    _index++;
    if (_index >= [_data count]) {
        _index = 0;
    }
    [self updatePlayerSetting];
    [self play];
}

// 下一首
- (void)nextMusicAction:(id)sender
{
    _index--;
    if (_index < 0) {
        _index = (int)[_data count] - 1;
    }
    [self updatePlayerSetting];
    [self play];
}

// 播放进度条
- (void)playProgress
{
    // 通过音频播放时长的百分比,给progressview进行赋值;
    _progressV.progress = _avAudioPlayer.currentTime / _avAudioPlayer.duration;
    
    int min = _avAudioPlayer.currentTime / 60;
    int second = (int)(_avAudioPlayer.currentTime) % 60;
    _progressTitle.text = [NSString stringWithFormat:@"%02d:%02d", min, second];
    
    min = _avAudioPlayer.duration / 60;
    second = (int)(_avAudioPlayer.duration) % 60;
    _progressMaxTitle.text = [NSString stringWithFormat:@"%02d:%02d", min, second];
}
// 声音开关(是否静音)
- (void)onOrOff:(UISwitch *)sender
{
    _avAudioPlayer.volume = sender.on;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTipsInfo:(NSString *)message
{
    CGSize screenSize = self.view.frame.size;
    
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [self.view addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(290, 9000)
                                             options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}
                                             context:nil
                        ].size;
    label.frame = CGRectMake(10, 5, labelSize.width, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2, screenSize.height - 160, labelSize.width+20, labelSize.height+10);
    [UIView animateWithDuration:1.5 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

#pragma -mark Delegate
// 播放完成时调用的方法  (代理里的方法),需要设置代理才可以调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
//    [_timer invalidate]; //NSTimer暂停   invalidate  使...无效;
    if (true) {
        [self pause];
        _progressTitle.text = @"00:00";
//        _progressV.progress = 0;
    }else{
        [self nextMusicAction:nil];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger hasEvaluated = [ud integerForKey:@"hasEvaluated"];
    if (!hasEvaluated)
    {
        int rate = [[MobClick getConfigParams:@"evaluateAlertRate"] intValue];
        int value = (arc4random() % 100) + 0;
        if (value <= rate)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[MobClick getConfigParams:@"evaluateNotifyContent"] delegate:self cancelButtonTitle:[MobClick getConfigParams:@"evaluateAlertCancelTitle"] otherButtonTitles:[MobClick getConfigParams:@"evaluateAlertConfirmTitle"], nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"hasEvaluated"];
        
        [BBFunction goToAppStoreEvaluate:842439221];
    }
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

@end
