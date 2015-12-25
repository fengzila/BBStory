//
//  BBMainViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBFindController.h"
#import "BBAppDelegate.h"
#import "BBRecorderObject.h"
#import "PlayViewController.h"
#import "BBDataManager.h"
#import "UMCommunity.h"
#import "BBGamesViewController.h"

@interface BBFindController ()

@property(nonatomic, strong) UIButton *openDrawerButton;

@end

@implementation BBFindController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initData
{
    _menuArr = @[@"社区", @"游戏"];
    _menuImgArr = @[@"menu_smallStory", @"menu_smallStory"];
}

- (void)loadView
{
    [self initData];
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    _statusBarHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _statusBarHeight = 20;
    }
    
    UIImage *btnMenu = [UIImage imageNamed:@"btn_menu"];
    NSParameterAssert(btnMenu);
    
    self.openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openDrawerButton.frame = CGRectMake(0.0f, _statusBarHeight + 0.0f, 44.0f, 44.0f);
    [self.openDrawerButton setImage:btnMenu forState:UIControlStateNormal];
    [self.openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openDrawerButton];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35 + _statusBarHeight, kDeviceWidth, 2)];
    line.image = [UIImage imageNamed:@"btn_bg"];
    [self.view addSubview:line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 35 + _statusBarHeight, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    BBAppDelegate *appDelegate = (BBAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.navigationController setNavigationBarHidden:YES animated:animated];
    
}

#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button

- (void)openDrawer:(id)sender
{
    [[[BBDataManager getInstance] getDrawer] open];
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0)
    {
        return 0;
    }
    return [_menuArr count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 55;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section != 0)
//    {
//        return 55;
//    }
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    static NSString *CellWithIdentifier = @"localCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [_menuArr objectAtIndex:row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.imageView.image = [UIImage imageNamed:[_menuImgArr objectAtIndex:row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    
    switch (row) {
        case 0:
        {
            UINavigationController *communityViewController = [UMCommunity getFeedsModalViewController];
            [self presentViewController:communityViewController animated:YES completion:^{
            }];
        }
            break;
        case 1:
        {
            BBGamesViewController *gameVC = [[BBGamesViewController alloc] init];
            [self.navigationController pushViewController:gameVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
