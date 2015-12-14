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
#import "BBTabbarViewController.h"

@interface BBRecordListController ()

@end

@implementation BBRecordListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        UIImage* image = [UIImage imageNamed:@"btn_back_n"];
        [backItem setBackButtonBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, image.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [backItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-400.f, 0) forBarMetrics:UIBarMetricsDefault];
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (id)initWithData:(NSData*)data Title:(NSString*)title
{
    self = [super init];
    if (self) {
        _data = data;
        _title = title;
    }
    return self;
}

- (void)loadView
{
    self.navigationItem.title = _title;
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    view.backgroundColor = kGray;
    
    BBStoryRecordTableView *storyView = [[BBStoryRecordTableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) Data:[NSKeyedUnarchiver unarchiveObjectWithData:_data]];
    storyView.delegate = self;
    [self.view addSubview:storyView];
}

- (void)pushInfoVCWithData:(BBRecorderObject*)data index:(int)index
{
    PlayViewController *infoVC = [[PlayViewController alloc] initWithIndex:index];
    [self.navigationController pushViewController:infoVC animated:YES];
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
