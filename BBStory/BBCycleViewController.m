//
//  BBCycleViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBCycleViewController.h"
#import "MobClick.h"
#import "UMOnlineConfig.h"
#import "BBDataManager.h"
#import "BBBannerManager.h"
#import "BBMainViewController.h"
#import "UMFeedback.h"
#import "BBDoRecordingController.h"

@interface BBCycleViewController ()

@end

@implementation BBCycleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"爸比讲故事";
    }
    return self;
}

- (id)initWithData:(NSArray*)data index:(int)index ConfigData:(NSDictionary *)configData
{
    self = [super init];
    if (self) {
        _data = data;
        _index = index;
        _configData = configData;
        _tabbarIsHidden = NO;
    }
    return self;
}

- (void)loadView
{
    _statusHeight = 0;
    self.drawer.DisEnableTouchMove = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _listView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _listView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:_listView];
    
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 44, kDeviceWidth, 44)];
//    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabbarView];
    
    _tabbarLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 2)];
    _tabbarLine.image = [UIImage imageNamed:@"btn_bg"];
    [_tabbarView addSubview:_tabbarLine];
    
    _recordingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_recordingBtn setFrame:CGRectMake(kDeviceWidth - 120 - 24, _tabbarView.height*.5 - 24*.5 - 2, 24, 24)];
    [_recordingBtn addTarget:self action:@selector(recordingAction) forControlEvents:UIControlEventTouchUpInside];
    [_recordingBtn setBackgroundImage:[UIImage imageNamed:@"btn_recording"] forState:UIControlStateNormal];
    [_tabbarView addSubview:_recordingBtn];
    
    _loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loveBtn setFrame:CGRectMake(kDeviceWidth - 70 - 32, _tabbarView.height*.5 - 32*.5, 32, 32)];
    [_loveBtn addTarget:self action:@selector(loveAction) forControlEvents:UIControlEventTouchUpInside];
    [_tabbarView addSubview:_loveBtn];
    
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setFrame:CGRectMake(kDeviceWidth - 20 - 32, _tabbarView.height*.5 - 32*.5, 32, 32)];
    [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [_moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [_tabbarView addSubview:_moreBtn];
    
    _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, _tabbarView.height)];
    _pageLabel.font = [UIFont boldSystemFontOfSize:16];
    _pageLabel.textColor = [UIColor colorWithRed:113.0f/255.0f green:113.0f/255.0f blue:113.0f/255.0f alpha:1.0f];
    _pageLabel.backgroundColor = [UIColor clearColor];
    _pageLabel.textAlignment = NSTextAlignmentLeft;
    [_tabbarView addSubview:_pageLabel];
    
    _csView = [[BBCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    _csView.delegate = self;
    _csView.datasource = self;
    [_csView setCurPage:_index];
    [_csView loadData];
//    [_csView roll];
    [_listView addSubview:_csView];
    
    _infoSettingView = [[BBInfoSettingView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
    _infoSettingView.delegate = self;
    [self.view addSubview:_infoSettingView];
    
//    _doRecordingView = [[BBDoRecordingView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
//    [self.view addSubview:_doRecordingView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [self loadAdBanner];
    
//    [[BBBannerManager getInstance] requestWithViewController:self];
    
    [self setDarkMode:[[BBDataManager getInstance] isDarkMode]];

}

- (void)recordingAction
{
    NSDictionary *curData = [_data objectAtIndex:_csView.curPage];
//    BBDoRecordingView* doRecordingView = [[BBDoRecordingView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) Data:curData ConfigData:_configData];
//    [self.view addSubview:doRecordingView];
////    [self presentViewController:doRecordingView animated:YES completion:nil];
//    [doRecordingView showWithAnimation];
    [MobClick event:@"touchRecorderShowBtn" attributes:@{@"recorderId" : [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]], @"name" : [curData objectForKey:@"title"]}];
    
    BBDoRecordingController* doRecordingVC = [[BBDoRecordingController alloc] initWithData:curData ConfigData:_configData];
    [self presentViewController:doRecordingVC animated:YES completion:nil];
}

- (void)loveAction
{
    @try{
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger hasEvaluated = [ud integerForKey:@"hasEvaluated"];
        if (!hasEvaluated)
        {
            int rate = [[UMOnlineConfig getConfigParams:@"evaluateAlertRate"] intValue];
            int value = (arc4random() % 100) + 0;
            if (value <= rate)
            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[UMOnlineConfig getConfigParams:@"evaluateNotifyContent"] delegate:self cancelButtonTitle:[UMOnlineConfig getConfigParams:@"evaluateAlertCancelTitle"] otherButtonTitles:[UMOnlineConfig getConfigParams:@"evaluateAlertConfirmTitle"], nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[UMOnlineConfig getConfigParams:@"evaluateNotifyContent"] delegate:self cancelButtonTitle:[UMOnlineConfig getConfigParams:@"evaluateAlertCancelTitle"] otherButtonTitles:[UMOnlineConfig getConfigParams:@"evaluateAlertReviewTitle"], [UMOnlineConfig getConfigParams:@"evaluateAlertConfirmTitle"], nil];
                [alert show];
            }
        }
        
        NSDictionary *curData = [_data objectAtIndex:_csView.curPage];
        
        NSMutableDictionary *dynamicLoveDic = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *loveDic = [ud objectForKey:[NSString stringWithFormat:@"%@loveDic", [_configData objectForKey:@"keyPrefix"]]];
        if (loveDic != Nil) {
            NSArray *keys;
            int i;
            id key;
            keys = [loveDic allKeys];
            
            int count = (int)[keys count];
            
            for (i = 0; i < count; i++)
            {
                key = [keys objectAtIndex: i];
                [dynamicLoveDic setObject:[loveDic objectForKey:key] forKey:key];
            }
        }
        
        NSString *k = [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]];
        
        if ([dynamicLoveDic objectForKey:k] == nil) {
            // 要被收藏的
            [_loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_loved"] forState:UIControlStateNormal];
            [dynamicLoveDic setValue:@1 forKey:k];
            [MobClick event:@"touchLoveBtn" attributes:@{@"recorderId" : [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]], @"name" : [curData objectForKey:@"title"]}];
        } else {
            [_loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlove"] forState:UIControlStateNormal];
            [dynamicLoveDic removeObjectForKey:k];
        }
        
        [ud setValue:dynamicLoveDic forKey:[NSString stringWithFormat:@"%@loveDic", [_configData objectForKey:@"keyPrefix"]]];
        [ud synchronize];
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

- (void)moreAction
{
    [_infoSettingView setFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    [_infoSettingView showWithAnimation];
}

- (void)setContentFontSize:(int)fontSize
{
    [_csView setContentFontSize:fontSize];
}

- (void)setDarkMode:(BOOL)isDarkMode
{
    [_csView setDarkMode:isDarkMode];
    if (isDarkMode) {
        _tabbarView.backgroundColor = [UIColor colorWithRed:17/255.0 green:17/255.0 blue:17/255.0 alpha:1];
        [_tabbarLine setAlpha:.12];
        self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    } else {
        _tabbarView.backgroundColor = [UIColor whiteColor];
        [_tabbarLine setAlpha:1];
        self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}

- (void)removeInfoSettingViewCallback
{
    [_infoSettingView setFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 吐槽
//        [self.navigationController pushViewController:[UMFeedback feedbackViewController]
//                                             animated:YES];
        [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
    }
    else if (buttonIndex == 2)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"hasEvaluated"];
        
        [BBFunction goToAppStoreEvaluate:842439221];
    }
}

- (void)changePage
{
    NSDictionary *curData = [_data objectAtIndex:_csView.curPage];
    NSString *key = [NSString stringWithFormat:@"%@", [curData objectForKey:@"id"]];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *loveDic = [ud objectForKey:[NSString stringWithFormat:@"%@loveDic", [_configData objectForKey:@"keyPrefix"]]];
    if (loveDic == Nil) {
        loveDic = [[NSMutableDictionary alloc] init];
    }
    
    if ([loveDic objectForKey:key] == nil) {
        // 没有被收藏的
        [_loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlove"] forState:UIControlStateNormal];
    } else {
        [_loveBtn setBackgroundImage:[UIImage imageNamed:@"btn_loved"] forState:UIControlStateNormal];
    }

    _pageLabel.text = [NSString stringWithFormat:@"%d/%d", (int)(_csView.curPage+1), (int)[_data count]];
    
    [ud setInteger:_csView.curPage forKey:[NSString stringWithFormat:@"%@lastReadPage", [_configData objectForKey:@"keyPrefix"]]];
}

- (NSInteger)numberOfPages
{
    return [_data count];
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    BBCycleScrollCell *cell = [[BBCycleScrollCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    NSDictionary *data = [_data objectAtIndex:index];
    [data setValue:[NSString stringWithFormat:@"%d/%d", (int)(index+1), (int)[_data count]] forKey:@"pageIndex"];
    [cell loadData:data];
    cell.delegate = self;
    return cell;
}

//- (void)didClickPage:(BBCycleScrollView *)csView atIndex:(NSInteger)index
//{
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollUp now");
        if (currentPostion > 0 && !_tabbarIsHidden)
        {
            [self hideTabBarWithAnimationDuration:0.6];
            _tabbarIsHidden = YES;
        }
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        //        NSLog(@"ScrollDown now");
        if (_tabbarIsHidden)
        {
            [self showTabBarWithAnimationDuration:0.4];
            _tabbarIsHidden = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (void)showTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarView.frame = CGRectMake(0, kDeviceHeight - _tabbarView.height, kDeviceWidth, _tabbarView.height);
                     }];
//    CGRect frame = _adBannerView.frame;
//    [UIView animateWithDuration:durationTime
//                     animations:^{
//                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, 0 + _statusHeight, frame.size.width, frame.size.height);
//                     }];
    [[BBBannerManager getInstance] showWithAnimationDuration:durationTime];
}

//隐藏TabBar通用方法
- (void)hideTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, _tabbarView.height);
                     }];
//    CGRect frame = _adBannerView.frame;
//    [UIView animateWithDuration:durationTime
//                     animations:^{
//                         _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, -frame.size.height - _statusHeight, frame.size.width, frame.size.height);
//                     }];
    [[BBBannerManager getInstance] hideWithAnimationDuration:durationTime];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [_doRecordingView stopRecord];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    // Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleDefault;
}

#pragma mark - DCPathButton delegate
- (void)button_0_action{
    NSLog(@"Button Press Tag 0!!");
    
}

- (void)button_1_action{
    NSLog(@"Button Press Tag 1!!");
}

@end
