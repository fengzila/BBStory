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
#import "BBCategoryTableView.h"

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
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    
    _baseView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, kDeviceHeight - 44)];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
    _baseView.delegate = self;
    
    _csView = [[BBHomeBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
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
    _data2 = [[NSMutableArray alloc] init];
    for (int i = 4; i < 6; i++) {
        [_data2 addObject:[data objectAtIndex:i]];
    }
    
    BBCategoryTableView *tableview1 = [[BBCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) Data:_data1];
    tableview1.frame = CGRectMake(0, _height+5, kDeviceWidth, [tableview1 adaptFrameHeight]);
    [_baseView addSubview:tableview1];
    _height += tableview1.height;
    
    [self loadSquareBanner];
    
    BBCategoryTableView *tableview2 = [[BBCategoryTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0) Data:_data2];
    tableview2.frame = CGRectMake(0, _height+5, kDeviceWidth, [tableview2 adaptFrameHeight]);
    [_baseView addSubview:tableview2];
    _height += tableview2.height;
    
    _baseView.contentSize = CGSizeMake(self.view.frame.size.width, _height);
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

- (void)pushInfoVC:(UIViewController *)viewController
{
    BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController pushViewController:viewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{}



#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BBDataManager getInstance] getCategoryDataList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 定义静态标识符
    static NSString *cellIdentifier = @"cell";
    NSInteger row = [indexPath row];
    //    NSUInteger section = [indexPath section];
    
    // 检查表视图中是否存在闲置的单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
        cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        
        UIImageView *imageP = [[UIImageView alloc]initWithFrame:CGRectMake(cell.frame.size.width-44, (90-70)/2, 44, 70)];
        imageP.image = [UIImage imageNamed:@"bt_04_J"];
        [cell addSubview:imageP];
        
        UIImageView *headImg = [[UIImageView alloc]initWithFrame:CGRectMake(90/2-60/2, 15, 60, 60)];
        headImg.tag = 10001;
        [cell addSubview:headImg];
        headImg.backgroundColor=[UIColor clearColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(88, 25, 100, 20)];
        title.tag = 10002;
        title.backgroundColor = [UIColor clearColor];
        title.textAlignment = 0;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont systemFontOfSize:15];
        [cell addSubview:title];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 89, kDeviceWidth - 20, 1)];
        line.image = [UIImage imageNamed:@"gwc_line_"];
        line.backgroundColor=[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
        [cell addSubview:line];
    }
    
    NSMutableArray *data = [[BBDataManager getInstance] getCategoryDataList];
    ((UIImageView*)[cell viewWithTag:10001]).image = [UIImage imageNamed:[[data objectAtIndex:row] objectForKey:@"img"]];
    ((UILabel*)[cell viewWithTag:10002]).text = [[data objectAtIndex:row] objectForKey:@"title"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if (section == 0)
    {
        NSMutableArray *categoryData = [[BBDataManager getInstance] getCategoryDataList];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:[[categoryData objectAtIndex:row] objectForKey:@"recordKey"]];
        NSString *title = [[categoryData objectAtIndex:row] objectForKey:@"title"];
        BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
//        BBRecordListController *recordVC = [[BBRecordListController alloc] initWithData:data Title:title];
//        [appDelegate.navigationController pushViewController:recordVC animated:YES];
    }
}


- (void)changePage
{
    
}

- (void)didClickPage:(BBHomeBannerScrollView *)csView atIndex:(NSInteger)index
{
    
}

- (NSInteger)numberOfPages
{
    return 2;
}

- (UIView *)pageAtIndex:(NSInteger)index
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
    view.backgroundColor = [UIColor whiteColor];
    if (index == 0) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 150)];
        image.image = [UIImage imageNamed:@"banner_1"];
        [view addSubview:image];
    } else {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
        CGRect frame = _adBannerView.frame;
        _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, _height, frame.size.width, frame.size.height);
        
        // Specify the ad unit ID.
        _adBannerView.adUnitID = @"ca-app-pub-4220651662523392/9739251261";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        _adBannerView.rootViewController = self;
        [view addSubview:_adBannerView];
        
        // Initiate a generic request to load it with an ad.
        [_adBannerView loadRequest:[GADRequest request]];
        
        view.backgroundColor = [UIColor redColor];
    }
    
    return view;
//    BBCycleScrollCell *cell = [[BBCycleScrollCell alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
//    NSDictionary *data = [_data objectAtIndex:index];
//    [data setValue:[NSString stringWithFormat:@"%d/%d", (int)(index+1), (int)[_data count]] forKey:@"pageIndex"];
//    [cell loadData:data];
//    cell.delegate = self;
//    return cell;
}

@end
