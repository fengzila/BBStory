//
//  BBMainViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBRecordListController.h"
#import "BBRecorderObject.h"
#import "PlayViewController.h"
#import "BBDataManager.h"

@interface BBRecordListController ()

@property(nonatomic, strong) UIButton *openDrawerButton;

@end

@implementation BBRecordListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    _statusBarHeight = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        _statusBarHeight = 20;
    }
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:false];
    
    UIImage *btnMenu = [UIImage imageNamed:@"btn_menu"];
    NSParameterAssert(btnMenu);
    
    self.openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.openDrawerButton.frame = CGRectMake(0.0f, _statusBarHeight + 0.0f, 44.0f, 44.0f);
    [self.openDrawerButton setImage:btnMenu forState:UIControlStateNormal];
    [self.openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.openDrawerButton];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger hasSawNewGames = [ud integerForKey:UD_HAS_SAWNEWGAMES];
    if (!hasSawNewGames)
    {
        UIImageView *tipsView = [[UIImageView alloc] initWithFrame:CGRectMake(28, 7, 10, 10)];
        tipsView.image = [UIImage imageNamed:@"tips"];
        [self.openDrawerButton addSubview:tipsView];
    }
    
    _segTitleArr = @[@"故事", @"唐诗"];
    _segControl = [[UISegmentedControl alloc]initWithItems:_segTitleArr];
    [_segControl setFrame:CGRectMake(90, _statusBarHeight + 2, kDeviceWidth - 180, 30)];
    _segControl.segmentedControlStyle = UISegmentedControlStyleBar;//设置样式
    [_segControl addTarget:self action:@selector(segContrllChange:)forControlEvents:UIControlEventValueChanged];
    NSDictionary *normalDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:247/255.0 green:45/255.0 blue:55/255.0 alpha:1],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
    NSDictionary *selectedDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:12.f],UITextAttributeFont, nil];
    [_segControl setTitleTextAttributes:normalDic forState:UIControlStateNormal];
    [_segControl setTitleTextAttributes:selectedDic forState:UIControlStateSelected];
    _segControl.tintColor = [UIColor colorWithRed:243/255.0 green:76/255.0 blue:51/255.0 alpha:1];
    _segControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segControl];
    
    NSData* storyData  = [[NSUserDefaults standardUserDefaults] objectForKey:UD_RECORDER_STORY_LIST];
    NSData* tangshiData  = [[NSUserDefaults standardUserDefaults] objectForKey:UD_RECORDER_TANGSHI_LIST];
    _storyView = [[BBStoryRecordTableView alloc] initWithFrame:CGRectMake(0, 36 + _statusBarHeight, kDeviceWidth, kDeviceHeight - 35) Data:[NSKeyedUnarchiver unarchiveObjectWithData:storyData]];
    _storyView.delegate = self;
    [self.view addSubview:_storyView];
    
    _tangshiView = [[BBStoryRecordTableView alloc] initWithFrame:CGRectMake(0, 36 + _statusBarHeight, kDeviceWidth, kDeviceHeight - 35) Data:[NSKeyedUnarchiver unarchiveObjectWithData:tangshiData]];
    _tangshiView.delegate = self;
    [self.view addSubview:_tangshiView];
    [_tangshiView setHidden:YES];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 35 + _statusBarHeight, kDeviceWidth, 2)];
    line.image = [UIImage imageNamed:@"btn_bg"];
    [self.view addSubview:line];
}

- (void)segContrllChange:(UISegmentedControl*)seg
{
    NSLog(@"Selected index %li (via UIControlEventValueChanged)", (long)seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex)
    {
        case 0:
            [_storyView setHidden:NO];
            [_tangshiView setHidden:YES];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:0];
            [[BBDataManager getInstance] setCurContentDataType:kContentDataTypeStory];
            break;
            
        case 1:
            [_storyView setHidden:YES];
            [_tangshiView setHidden:NO];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:1];
            [[BBDataManager getInstance] setCurContentDataType:kContentDataTypeTangshi];
            break;
            
        default:
            break;
    }
}

- (void)pushInfoVCWithData:(BBRecorderObject*)data index:(int)index
{
    PlayViewController *infoVC = [[PlayViewController alloc] initWithIndex:index];
    infoVC.drawer = self.drawer;
    [self.navigationController pushViewController:infoVC animated:YES];
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
    [self.drawer open];
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
