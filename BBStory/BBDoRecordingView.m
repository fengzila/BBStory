//
//  BBDueDatePickerView.m
//  BB
//
//  Created by FengZi on 14-1-16.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBDoRecordingView.h"
#import "MobClick.h"
#import "BBDataManager.h"
#import "BBBannerManager.h"
#import "BBRecorderObject.h"

@implementation BBDoRecordingView

- (id)initWithFrame:(CGRect)frame Data:(NSDictionary*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        _isRecording = NO;
        _data = data;
        
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, _bgView.height);
        _bgView.alpha = 1;
        [self addSubview:_bgView];
        
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
        _tabbarView.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_tabbarView];
        
        _tabbarLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 2)];
        _tabbarLine.image = [UIImage imageNamed:@"btn_bg"];
        [_tabbarView addSubview:_tabbarLine];
        
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setFrame:CGRectMake(20, _tabbarView.height*.5 - 32*.5, 32, 32)];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
        [_tabbarView addSubview:backBtn];
        
        _recordingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordingBtn setFrame:CGRectMake(kDeviceWidth * .5f - 64*.5, - 64*.5 + 8, 64, 64)];
        [_recordingBtn addTarget:self action:@selector(recordingAction) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:_recordingBtn];
        
        _recordTimeTips = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 120 - 10, kDeviceHeight - 44 - 25, 120, 25)];
        _recordTimeTips.backgroundColor = [UIColor clearColor];
        _recordTimeTips.textAlignment = NSTextAlignmentCenter;
        _recordTimeTips.textColor = [UIColor grayColor];
        _recordTimeTips.font = [UIFont systemFontOfSize:16];
        _recordTimeTips.text = @"录音 00:00";
        [_bgView addSubview:_recordTimeTips];
        
        UISlider *sliderVolume=[[UISlider alloc]initWithFrame:CGRectMake(kDeviceWidth * .5 - 257 * .5, kDeviceHeight - 44 - 64, 257, 7)];
        sliderVolume.backgroundColor = [UIColor clearColor];
        sliderVolume.value=0.1;
        sliderVolume.minimumValue=0;
        sliderVolume.maximumValue=1.0;
        //滑块拖动时的事件
        [sliderVolume addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        //滑动拖动后的事件
//        [sliderVolume addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        
        _volumeTips = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44 - 64 - 36, kDeviceWidth, 25)];
        _volumeTips.backgroundColor = [UIColor clearColor];
        _volumeTips.textAlignment = NSTextAlignmentCenter;
        _volumeTips.textColor = [UIColor grayColor];
        _volumeTips.font = [UIFont systemFontOfSize:12];
        int volume = floorf(sliderVolume.value * 100);
        _volumeTips.text = [NSString stringWithFormat:@"配乐音量：%d%%", volume];
        [_bgView addSubview:_volumeTips];
        
        _bgMusicBtn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgMusicBtn0.tag = 100;
        [_bgMusicBtn0 setFrame:CGRectMake(kDeviceWidth * 1/5 - 55*.5, kDeviceHeight - 44 - 64 - 42 - 64, 55, 55)];
        [_bgMusicBtn0 addTarget:self action:@selector(bgMusicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgMusicBtn0 setBackgroundImage:[UIImage imageNamed:@"record_bgMusic_local"] forState:UIControlStateNormal];
        [_bgView addSubview:_bgMusicBtn0];
        [_bgMusicBtn0 setTitle:@"无配乐" forState:UIControlStateNormal];
        [_bgMusicBtn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bgMusicBtn0.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        _bgMusicBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgMusicBtn1.tag = 101;
        [_bgMusicBtn1 setFrame:CGRectMake(kDeviceWidth * 2/5 - 55*.5, kDeviceHeight - 44 - 64 - 42 - 64, 55, 55)];
        [_bgMusicBtn1 addTarget:self action:@selector(bgMusicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgMusicBtn1 setBackgroundImage:[UIImage imageNamed:@"record_bgMusic_n"] forState:UIControlStateNormal];
        [_bgView addSubview:_bgMusicBtn1];
        [_bgMusicBtn1 setTitle:@"抒情" forState:UIControlStateNormal];
        [_bgMusicBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bgMusicBtn1.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        _bgMusicBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgMusicBtn2.tag = 102;
        [_bgMusicBtn2 setFrame:CGRectMake(kDeviceWidth * 3/5 - 55*.5, kDeviceHeight - 44 - 64 - 42 - 64, 55, 55)];
        [_bgMusicBtn2 addTarget:self action:@selector(bgMusicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgMusicBtn2 setBackgroundImage:[UIImage imageNamed:@"record_bgMusic_n"] forState:UIControlStateNormal];
        [_bgView addSubview:_bgMusicBtn2];
        [_bgMusicBtn2 setTitle:@"欢乐" forState:UIControlStateNormal];
        [_bgMusicBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bgMusicBtn2.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        _bgMusicBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgMusicBtn3.tag = 103;
        [_bgMusicBtn3 setFrame:CGRectMake(kDeviceWidth * 4/5 - 55*.5, kDeviceHeight - 44 - 64 - 42 - 64, 55, 55)];
        [_bgMusicBtn3 addTarget:self action:@selector(bgMusicAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgMusicBtn3 setBackgroundImage:[UIImage imageNamed:@"record_bgMusic_n"] forState:UIControlStateNormal];
        [_bgView addSubview:_bgMusicBtn3];
        [_bgMusicBtn3 setTitle:@"幽静" forState:UIControlStateNormal];
        [_bgMusicBtn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _bgMusicBtn3.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        [self bgMusicAction:_bgMusicBtn0];
        
        _controlLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 44 - 64 - 42 - 64 - 14, kDeviceWidth, 2)];
        _controlLine.image = [UIImage imageNamed:@"btn_bg"];
        [_bgView addSubview:_controlLine];
        
        _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.frame.size.height - 44 - 64 - 42 - 64 - 14)];
        _contentWebView.scalesPageToFit = NO;
        _contentWebView.backgroundColor = [UIColor clearColor];
        _contentWebView.opaque = NO;
        _contentWebView.delegate = self;
        [self addSubview:_contentWebView];
        NSString *contentStr = [data objectForKey:@"content"];
        NSString *contentStrFormat = [NSString stringWithFormat:@"    <html><body style=\"font-size:16px;\">%@</body></html>", contentStr];
        [_contentWebView loadHTMLString:contentStrFormat baseURL:nil];
        
        if ([[BBDataManager getInstance] isDarkMode]) {
            _bgView.backgroundColor = [UIColor colorWithRed:24/255.0 green:25/255.0 blue:26/255.0 alpha:1];
            _tabbarView.backgroundColor = [UIColor colorWithRed:24/255.0 green:25/255.0 blue:26/255.0 alpha:1];
            [_tabbarLine setAlpha:.12];
            [_controlLine setAlpha:.12];
            [sliderVolume setMinimumTrackTintColor:[UIColor colorWithRed:69/255.0 green:152/255.0 blue:230/255.0 alpha:1]];
            [sliderVolume setMaximumTrackTintColor:[UIColor grayColor]];
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_start_dark"] forState:UIControlStateNormal];
        } else {
            [sliderVolume setMinimumTrackTintColor:[UIColor colorWithRed:243/255.0 green:76/255.0 blue:51/255.0 alpha:1]];
            _tabbarView.backgroundColor = [UIColor whiteColor];
            [_tabbarLine setAlpha:1];
            [_controlLine setAlpha:1];
            [sliderVolume setMaximumTrackTintColor:[UIColor blackColor]];
            _bgView.backgroundColor = [UIColor whiteColor];
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_start"] forState:UIControlStateNormal];
        }
        [_bgView addSubview:sliderVolume];
        
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        switch ([[BBDataManager getInstance] getCurContentDataType]) {
            case kContentDataTypeStory:
                _recorderName = [NSString stringWithFormat:@"%@/story_%@.caf", docDir, [_data objectForKey:@"id"]];
                _saveKey = UD_RECORDER_STORY_LIST;
                break;
            case kContentDataTypeTangshi:
                _recorderName = [NSString stringWithFormat:@"%@/tangshi_%@.caf", docDir, [_data objectForKey:@"id"]];
                _saveKey = UD_RECORDER_TANGSHI_LIST;
                break;
                
            default:
                break;
        }
        //录音设置
        _recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                               [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                               [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                               [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                               [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                               nil];
        
        [self setAudioSession];
        
        NSData* data  = [[NSUserDefaults standardUserDefaults] objectForKey:_saveKey];
        NSMutableArray *dataArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        for (BBRecorderObject *obj in dataArr) {
//            NSLog(@"RRRR--->%@-----%@", obj.recorderId, [_data objectForKey:@"id"]);
            if ([obj.recorderId isEqualToNumber: [_data objectForKey:@"id"]]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经有录音了呦，是否要覆盖？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                [alert show];
                break;
            }
        }
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self backAction];
    }
}

/**
 *  设置音频会话
 */
-(void)setAudioSession{
//    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
//    //设置为播放和录音状态，以便可以在录制完之后播放录音
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
//    [audioSession setActive:YES error:nil];
    
    // 启用混合，音频路由到主音箱，并激活了session
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    OSStatus propertySetError = 0;
    UInt32 allowMixing = true;
    propertySetError = AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMixing), &allowMixing);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof (audioRouteOverride),&audioRouteOverride);
    NSLog(@"Mixing: %x", propertySetError); // This should be 0 or there was an issue somewhere
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

//封装系统加载函数
- (void)playMusic:(NSString*)name type:(NSString*)type
{
    if (_avAudioPlayer) {
        _avAudioPlayer = nil;
    }
    NSError *error = nil;
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:name withExtension:type];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    
//    _avAudioPlayer.delegate = self;
    _avAudioPlayer.volume = 0.1;
    // 单曲循环
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer prepareToPlay];
    [_avAudioPlayer play];
    
    if(error){
        NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
    }
    
    NSLog(@"songName is %@", name);
}

- (void)showWithAnimation
{
    [UIView animateWithDuration:0.4
                     animations:^{
                         _bgView.frame = CGRectMake(0, kDeviceHeight - _bgView.height, kDeviceWidth, _bgView.height);
                     }];
    
    [[BBBannerManager getInstance] hideWithAnimationDuration:0.4];
}

- (void)hiddenWithAnimation
{
    _bgView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.4
                     animations:^{
                         _bgView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, _bgView.height);
                         [self removeFromSuperview];
                     }];
    [[BBBannerManager getInstance] showWithAnimationDuration:0.4];
}

- (void)backAction
{
    if (_isRecording) {
        _recorder = nil;
        _avAudioPlayer = nil;
        [timer invalidate];
        timer = nil;
    }
    [self hiddenWithAnimation];
}

- (void)recordingAction
{
    if (_isRecording) {
        // 结束录音 保存
        if ([[BBDataManager getInstance] isDarkMode]) {
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_start_dark"] forState:UIControlStateNormal];
        } else {
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_start"] forState:UIControlStateNormal];
        }
        
        //录音停止
        [_recorder stop];
        _recorder = nil;
        //结束定时器
        [timer invalidate];
        timer = nil;
        _avAudioPlayer = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"录音已保存成功。\n请到【我的录音】中查看"
                                       delegate:nil
                              cancelButtonTitle:@"好的"
                              otherButtonTitles:nil] show];
        });
        
        NSData* data  = [[NSUserDefaults standardUserDefaults] objectForKey:_saveKey];
        NSArray *decodeArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSMutableArray* array = [[NSMutableArray alloc] initWithArray:decodeArray];
        BBRecorderObject *recorderObj = [[BBRecorderObject alloc] init];
        recorderObj.recorderId = [_data objectForKey:@"id"];
        recorderObj.name = [_data objectForKey:@"title"];
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yy/MM/dd"];
        recorderObj.time = [dateFormatter stringFromDate:[NSDate date]];
        
        for (int i = 0; i < [array count]; i++) {
            BBRecorderObject *obj = [array objectAtIndex:i];
            if ([obj.recorderId isEqualToNumber: [_data objectForKey:@"id"]]) {
                [array removeObjectAtIndex:i];
                break;
            }
        }
        [array addObject:recorderObj];
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:_saveKey];
        
        [MobClick event:@"touchRecorderEndBtn" attributes:@{@"recorderId" : [_data objectForKey:@"id"], @"name" : [_data objectForKey:@"title"]}];
    } else {
        // 开始录音
        _recorderDuration = 0.0f;
        if ([[BBDataManager getInstance] isDarkMode]) {
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_pause_dark"] forState:UIControlStateNormal];
        } else {
            [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_record_pause"] forState:UIControlStateNormal];
        }
        
        NSError *error = nil;
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_recorderName] settings:_recorderSettingsDict error:&error];
        _recorder.delegate = self;
        
        if (_recorder) {
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            [_recorder record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recorderTimer:) userInfo:nil repeats:YES];
            
        } else
        {
//            int errorCode = (int)CFSwapInt32HostToBig ([error code]);
//            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
        
        [_avAudioPlayer setCurrentTime:0];
        
        [MobClick event:@"touchRecorderBeginBtn" attributes:@{@"recorderId" : [_data objectForKey:@"id"], @"name" : [_data objectForKey:@"title"]}];
    }
    
    _isRecording = !_isRecording;
}



-(void)recorderTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [_recorder updateMeters];
    
    _recorderDuration += timer_.timeInterval;
    _recordTimeTips.text = [NSString stringWithFormat:@"%@", [self timeFormat:_recorderDuration]];
}

- (NSString*)timeFormat:(NSInteger)t
{
    NSInteger h = floorf(t / (60 * 60));
    NSInteger m = floorf((t - h * 60 * 60) / 60);
    NSInteger s = floorf(t - h * 60 * 60 - m * 60);
    
    if (h > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", h, m, s];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld", m, s];
    }
}

-(void)sliderValueChanged:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    int volume = floorf(slider.value * 100);
    _volumeTips.text = [NSString stringWithFormat:@"配乐音量：%d%%", volume];
    _avAudioPlayer.volume = slider.value;
}

-(void)bgMusicAction:(id)sender
{
    NSString *bgMusicImageName;
    NSString *bgMusicImageLightName;
    UIColor *normalColor;
    UIColor *lightColor;
    if ([[BBDataManager getInstance] isDarkMode]) {
        bgMusicImageName = @"record_bgMusic_n_dark";
        bgMusicImageLightName = @"record_bgMusic_dark";
        normalColor = [UIColor colorWithRed:69/255.0 green:152/255.0 blue:230/255.0 alpha:1];
        lightColor = [UIColor blackColor];
    } else {
        bgMusicImageName = @"record_bgMusic_n";
        bgMusicImageLightName = @"record_bgMusic_local";
        normalColor = [UIColor blackColor];
        lightColor = [UIColor whiteColor];
    }
    [_bgMusicBtn0 setBackgroundImage:[UIImage imageNamed:bgMusicImageName] forState:UIControlStateNormal];
    [_bgMusicBtn1 setBackgroundImage:[UIImage imageNamed:bgMusicImageName] forState:UIControlStateNormal];
    [_bgMusicBtn2 setBackgroundImage:[UIImage imageNamed:bgMusicImageName] forState:UIControlStateNormal];
    [_bgMusicBtn3 setBackgroundImage:[UIImage imageNamed:bgMusicImageName] forState:UIControlStateNormal];
    [_bgMusicBtn0 setTitleColor:normalColor forState:UIControlStateNormal];
    [_bgMusicBtn1 setTitleColor:normalColor forState:UIControlStateNormal];
    [_bgMusicBtn2 setTitleColor:normalColor forState:UIControlStateNormal];
    [_bgMusicBtn3 setTitleColor:normalColor forState:UIControlStateNormal];
    int tag = (int)[sender tag];
    NSLog(@"btn tag is %d", tag);
    switch (tag) {
        case 100:
            [_bgMusicBtn0 setBackgroundImage:[UIImage imageNamed:bgMusicImageLightName] forState:UIControlStateNormal];
            [_bgMusicBtn0 setTitleColor:lightColor forState:UIControlStateNormal];
            [_avAudioPlayer stop];
            break;
        case 101:
            [_bgMusicBtn1 setBackgroundImage:[UIImage imageNamed:bgMusicImageLightName] forState:UIControlStateNormal];
            [_bgMusicBtn1 setTitleColor:lightColor forState:UIControlStateNormal];
            [self playMusic:@"美人计" type:@"mp3"];
            break;
        case 102:
            [_bgMusicBtn2 setBackgroundImage:[UIImage imageNamed:bgMusicImageLightName] forState:UIControlStateNormal];
            [_bgMusicBtn2 setTitleColor:lightColor forState:UIControlStateNormal];
            [self playMusic:@"SweetDreams" type:@"mp3"];
            break;
        case 103:
            [_bgMusicBtn3 setBackgroundImage:[UIImage imageNamed:bgMusicImageLightName] forState:UIControlStateNormal];
            [_bgMusicBtn3 setTitleColor:lightColor forState:UIControlStateNormal];
            [self playMusic:@"You Are Haneulmalraria" type:@"mp3"];
            break;
            
        default:
            break;
    }
}

- (void)setContentFontSize:(int)fontSize
{
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'", fontSize];
    [_contentWebView stringByEvaluatingJavaScriptFromString:str];
}

- (void)setDarkModeOther:(BOOL)isDarkMode
{
    if (isDarkMode) {
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'gray'"];
        _contentWebView.scrollView.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1];
    } else {
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'black'"];
        _contentWebView.scrollView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setDarkMode:(BOOL)isDarkMode
{
    [self setDarkModeOther:isDarkMode];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self setContentFontSize:[[BBDataManager getInstance] getContentFontSize]];
    [self setDarkModeOther:[[BBDataManager getInstance] isDarkMode]];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"Finish record!");
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    NSLog(@"Encode Error occurred:%@", error);
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
