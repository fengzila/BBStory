//
//  UIViewController+BBUserViewController.m
//  BBStory
//
//  Created by Fengzi on 15/12/4.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import "BBHomeViewController.h"
#import "BBAppDelegate.h"
#import "BBDataManager.h"
#import "BBMainViewController.h"
#import "BBCycleViewController.h"

@implementation BBHomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView
{
    _height = 0;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    _baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kDeviceHeight - 44)];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
    _baseView.delegate = self;
    
    _csView = [[BBHomeBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*.45f)];
    _csView.delegate = self;
    _csView.datasource = self;
    [_csView setCurPage:0];
    [_csView loadData];
    [_baseView addSubview:_csView];
    
    _height += _csView.height;
    
    NSMutableArray *data = [[BBDataManager getInstance] getCategoryDataList];
    _data1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        [_data1 addObject:[data objectAtIndex:i]];
    }
//    _data2 = [[NSMutableArray alloc] init];
//    for (int i = 4; i < 6; i++) {
//        [_data2 addObject:[data objectAtIndex:i]];
//    }
    
    BBCategoryTableView *tableview1 = [[BBCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) Data:_data1];
    tableview1.frame = CGRectMake(0, _height+5, kDeviceWidth, [tableview1 adaptFrameHeight]);
    [_baseView addSubview:tableview1];
    tableview1.delegate = self;
    _height += tableview1.height;
    
//    [self loadSquareBanner];
//    
//    BBCategoryTableView *tableview2 = [[BBCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) Data:_data2];
//    tableview2.frame = CGRectMake(0, _height+5, kDeviceWidth, [tableview2 adaptFrameHeight]);
//    [_baseView addSubview:tableview2];
//    _height += tableview2.height;
    
    _baseView.contentSize = CGSizeMake(self.view.frame.size.width, _height + 30);
}

-(void)loadBanner
{
    if (kDeviceWidth > 640) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
//        _adBannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFullWidthPortraitWithHeight(150)];
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
    }
    CGRect frame = _adBannerView.frame;
    _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, _height, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
    _adBannerView.adUnitID = @"ca-app-pub-4220651662523392/9739251261";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adBannerView.rootViewController = self;
    [_baseView addSubview:_adBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adBannerView loadRequest:[GADRequest request]];
}

-(void)loadSquareBanner
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, _height + 10, 100, 20)];
    title.text = @"爸比的小广告";
    title.backgroundColor = [UIColor clearColor];
    [title setTextAlignment:NSTextAlignmentLeft];
    title.textColor = [UIColor blackColor];
    title.font = [UIFont systemFontOfSize:15];
    [_baseView addSubview:title];
    
    _height += 20 + title.height;
    
    if (kDeviceWidth > 640) {
        _adSquareBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
        _adSquareBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
    }
    CGRect frame = _adSquareBannerView.frame;
    _adSquareBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, _height, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
//    _adSquareBannerView.adUnitID = @"ca-app-pub-4220651662523392/8061564860";
    _adSquareBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adSquareBannerView.rootViewController = self;
    [_baseView addSubview:_adSquareBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adSquareBannerView loadRequest:[GADRequest request]];
    
    _height += _adSquareBannerView.height + 10;
}

- (void)pushInfoVCWithIndex:(int)index
{
    BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
    NSMutableArray *data = [[BBDataManager getInstance] getCategoryDataList];
    BBMainViewController *mainVC = [[BBMainViewController alloc] initWithData:[data objectAtIndex:index]];
    [appDelegate.navigationController pushViewController:mainVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{}

- (void)changePage
{
    
}

- (void)didClickPage:(BBHomeBannerScrollView *)csView atIndex:(NSInteger)index
{
    if (index == 0) {
        BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
        NSMutableArray *categoryData = [[BBDataManager getInstance] getCategoryDataList];
        int i = (arc4random() % [categoryData count]) + 0;
        NSDictionary *configData = [categoryData objectAtIndex:i];
        NSMutableArray *data = [[BBDataManager getInstance] getDataListWithKey:[configData objectForKey:@"dataKey"]];
        int j = (arc4random() % [data count]) + 0;
        
        BBCycleViewController *infoVC = [[BBCycleViewController alloc] initWithData:data index:j ConfigData:configData];
        
        [appDelegate.navigationController pushViewController:infoVC animated:YES];
    }
}

- (NSInteger)numberOfPages
{
    return 2;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*.45f)];
    view.backgroundColor = [UIColor whiteColor];
    if (index == 0) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*.45f)];
        image.image = [UIImage imageNamed:@"banner_1"];
        [view addSubview:image];
    } else {
        view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*.45f)];
        image.image = [UIImage imageNamed:@"banner_3"];
        [view addSubview:image];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceWidth*.45)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = .5f;
        [view addSubview:bgView];
        
        if (kDeviceWidth > 640) {
            _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
        } else {
            _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLargeBanner];
        }
        CGRect frame = _adBannerView.frame;
        _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, (kDeviceWidth*.45 - frame.size.height)*.5f, frame.size.width, frame.size.height);
        
        // Specify the ad unit ID.
        _adBannerView.adUnitID = @"ca-app-pub-4220651662523392/9739251261";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        _adBannerView.rootViewController = self;
        [view addSubview:_adBannerView];
        
        // Initiate a generic request to load it with an ad.
        [_adBannerView loadRequest:[GADRequest request]];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, kDeviceWidth*.45 - 26, kDeviceWidth, 30)];
        title.text = @"爸比小广告";
        title.backgroundColor = [UIColor clearColor];
        [title setTextAlignment:NSTextAlignmentLeft];
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont systemFontOfSize:14];
        [view addSubview:title];
        
        UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(-10, kDeviceWidth*.45 - 26, kDeviceWidth, 30)];
        info.text = @"Google提供";
        info.backgroundColor = [UIColor clearColor];
        [info setTextAlignment:NSTextAlignmentRight];
        info.textColor = [UIColor whiteColor];
        info.font = [UIFont systemFontOfSize:14];
        [view addSubview:info];
    }
    
    return view;
}

@end
