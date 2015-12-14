//
//  BBMainViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBRecordCategoryListController.h"
#import "BBDataManager.h"
#import "BBAppDelegate.h"
#import "BBRecordListController.h"

@interface BBRecordCategoryListController ()

@end

@implementation BBRecordCategoryListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        UIImage* image = [UIImage imageNamed:@"btn_back_n"];
        [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = backItem;
        
        self.navigationItem.title = @"我的录音";
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor colorWithRed:.98 green:.98 blue:.98 alpha:1.0];
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorColor=[UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

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
        title.textColor = [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:1.0];
        title.font = [UIFont systemFontOfSize:14];
        [cell addSubview:title];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 89, 320, 1)];
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
        BBRecordListController *recordVC = [[BBRecordListController alloc] initWithData:data Title:title];
        [appDelegate.navigationController pushViewController:recordVC animated:YES];
    }
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

@end
