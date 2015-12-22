//
//  BBMainViewController.m
//  BB
//
//  Created by FengZi on 13-12-24.
//  Copyright (c) 2013年 FengZi. All rights reserved.
//

#import "BBTabbarViewController.h"
#import "BBNavigationController.h"
#import "BBHomeViewController.h"
#import "BBUserViewController.h"
#import "UMCommunity.h"
#import "BBAppDelegate.h"

BBTabbarViewController *instance = Nil;

@interface BBTabbarViewController ()

// 初始化数据
- (void)initData;

// 装在子视图控制器
- (void)loadViewControllers;

// 自定义tabbar视图
- (void)customTabbarView;

@end

@implementation BBTabbarViewController

+ (BBTabbarViewController*)mainVCInstance
{
    return instance;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden=YES;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tabBar.hidden = YES;
    for (UIView *view in self.view.subviews) {
        if (![view isKindOfClass:[UITabBar class]]) {
            view.frame = CGRectMake(0, 0, 320, 480);
        }
    }
    
    [self initData];
    
    [self customTabbarView];
    
    instance = self;
    
    [self loadViewControllers];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIImage* image = [UIImage imageNamed:@"btn_back_n"];
    [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.title = [_titles objectAtIndex:0];
    
}

- (void)initData
{
    _imgs = @[@"tabbar_home", @"tabbar_find", @"tabbar_me"];
    _titles = @[@"首页", @"爸比说", @"我的"];
    _pos = @[[NSString stringWithFormat:@"%f", kDeviceWidth / 4 - 10], [NSString stringWithFormat:@"%f", kDeviceWidth / 2], [NSString stringWithFormat:@"%f", kDeviceWidth * 3 / 4 + 10]];
}

- (void)loadViewControllers
{
    // 首页
    BBHomeViewController *homeVC = [[BBHomeViewController alloc] init];
    BBNavigationController *mainNavigation = [[BBNavigationController alloc] initWithRootViewController:homeVC];
    
    // 爸比说
    UINavigationController *communityNavigation = [UMCommunity getFeedsModalViewController];
    
    // 我的
    BBUserViewController *userVC = [[BBUserViewController alloc] init];
    BBNavigationController *userNavigation = [[BBNavigationController alloc] initWithRootViewController:userVC];
    
    NSArray *viewControllers = @[mainNavigation, communityNavigation, userNavigation];
    [self setViewControllers:viewControllers animated:YES];
}

- (void)customTabbarView
{
    // 自定义tabbar背景视图
    _tabbarBg = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - 54, kDeviceWidth, 54)];;
    _tabbarBg.userInteractionEnabled = YES;
    _tabbarBg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabbarBg];
    
    UIImageView *tabbarLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, kDeviceWidth, 2)];
    tabbarLine.image = [UIImage imageNamed:@"btn_bg"];
    [_tabbarBg addSubview:tabbarLine];
    
    _tabbarItemArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; i++)
    {
        int x = [_pos[i] intValue];
        
        BOOL withText = YES;
        BBItemView *itemView = [[BBItemView alloc] initWithFrame:CGRectMake(x - 46 / 2, _tabbarBg.height/2.0 - 46.0/2, 46, 46) WithText:withText];
        itemView.tag = i;
        itemView.delegate = self;
        itemView.item.image = [UIImage imageNamed:_imgs[i]];
        NSString *selectItemImgName = [[NSString alloc] initWithFormat:@"%@_h", _imgs[i]];
        itemView.selectItem.image = [UIImage imageNamed:selectItemImgName];
        itemView.title.text = _titles[i];
        itemView.title.font = [UIFont systemFontOfSize:10];
        [itemView.title setTextColor:kTabbarHightFontColor];
        [_tabbarBg addSubview:itemView];
        
        if (i == 0)
        {
            [self touchItemView:itemView atIndex:i];
        }
        
        [_tabbarItemArr addObject:itemView];
    }
}

- (void)touchItemView:(BBItemView *)itemView atIndex:(NSInteger)index
{
    self.selectedIndex = index;
    
    for (int i = 0; i < [_tabbarItemArr count]; i++)
    {
        BBItemView *itemView = [_tabbarItemArr objectAtIndex:i];
        [itemView.title setTextColor:kTabbarHightFontColor];
        itemView.item.image = [UIImage imageNamed:_imgs[i]];
    }
    
    [itemView.title setTextColor:kTabbarFontColor];
    itemView.item.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_h", _imgs[index]]];
    
    BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController setNavigationBarHidden:(index==1) animated:NO];
    
    self.navigationItem.title = [_titles objectAtIndex:index];
}

- (void)showTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarBg.frame = CGRectMake(0, kDeviceHeight - 54, kDeviceWidth, 54);
                     }];
    
}

//隐藏TabBar通用方法
- (void)hideTabBarWithAnimationDuration:(CGFloat)durationTime
{
    [UIView animateWithDuration:durationTime
                     animations:^{
                         _tabbarBg.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, 54);
                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//
//- (void)dealloc
//{
////    [_tabbarBg rele
//    [super dealloc];
//}


@end
