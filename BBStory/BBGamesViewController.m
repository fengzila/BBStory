//
//  ICSPlainColorViewController.m
//
//  Created by Vito Modena
//
//  Copyright (c) 2014 ice cream studios s.r.l. - http://icecreamstudios.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "BBGamesViewController.h"
#import "CustomURLCache.h"
#import "MBProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "BBDataManager.h"
#import "BBTabbarViewController.h"

static NSString * const kGamesViewControllerCellReuseId = @"kGamesViewControllerCellReuseId";

@interface BBGamesViewController ()

@end


@implementation BBGamesViewController

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    self.view.backgroundColor = kGray;
    
    int statusBarHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    
    self.navigationItem.title = @"爸比的游戏";
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, statusBarHeight + 10, kDeviceWidth, 25)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.text = @"我的游乐场";
    [self.view addSubview:titleLabel];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, statusBarHeight + 50, kDeviceWidth, 25)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.textColor = [UIColor grayColor];
    tipsLabel.font = [UIFont boldSystemFontOfSize:12];
    tipsLabel.text = @"下载";
    [self.view addSubview:tipsLabel];
    
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, statusBarHeight + 45, kDeviceWidth, kDeviceHeight - 45)];
//    webView.delegate = self;
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://1.xiaobaba.sinaapp.com/ad/games.html"]];
//    [webView loadRequest:request];
//    [self.view addSubview: webView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight + 40, kDeviceWidth, kDeviceHeight - statusBarHeight - 40) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [[BBDataManager getInstance] getDrawer].DisEnableTouchMove = YES;
}

- (void)initData
{
    _titleArr = @[@"奔跑吧，火柴人！", @"消灭星星精简版", @"2048后宫版", @"双车快跑", @"2048无尽版", @"天天拼图 - 牛刀小试", @"Space Rover"];
    _imgArr = @[@"games_stick", @"games_popstar", @"games_hougong", @"games_2car", @"games_2048", @"games_pintu", @"games_spacerover"];
    _descArr = @[@"你能让火柴人跑多远呢？", @"只要两个相同颜色的星星就可以消除", @"当然，玩腻了数字了，也可以尝试下后宫~", @"拼反应，拼左右脑，拼左右手，还不试试？", @"经典的数字消除游戏，挑战你的合并思维，扛得住吗？", @"内置三大主题，绝对让你拼到手软，根本停不下来。", @"好玩的物理跑酷游戏"];
    _appIdArr = @[@943437782, @1022010323, @950315051, @949241639, @882303787, @876313246, @1028790543];
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController == self)
//    {
//        [[BBBaseViewController mainVCInstance] hideTabBarWithAnimationDuration:0.6];
//        [navigationController setNavigationBarHidden:NO animated:animated];
//    } else {
//        [navigationController setNavigationBarHidden:YES animated:animated];
//    }
//}

#pragma mark - webview

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading...";
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if(section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGamesViewControllerCellReuseId];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kGamesViewControllerCellReuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        cell.textLabel.text = [_titleArr objectAtIndex:row];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        
        cell.detailTextLabel.text = [_descArr objectAtIndex:row];
        
        UIImage *img= [UIImage imageNamed:[_imgArr objectAtIndex:row]];
        cell.imageView.image = img;
        cell.imageView.layer.cornerRadius = 8;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
//    NSUInteger section = [indexPath section];
    
    [BBFunction goToAppStoreEvaluate:[[_appIdArr objectAtIndex:row] intValue]];
}


@end