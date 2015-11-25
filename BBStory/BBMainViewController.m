//
//  BBMainViewController.m
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import "BBStoryInfoViewController.h"
#import "BBMainViewController.h"
#import "BBNetworkService.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "BBCycleViewController.h"
#import "BBDataManager.h"

@interface BBMainViewController ()

@property(nonatomic, strong) UIButton *openDrawerButton;

@end

@implementation BBMainViewController

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
    
    _segTitleArr = @[@"全部", @"收藏"];
//    _segControl = [[BBSegmentedControl alloc] initWithSectionTitles:_segTitleArr];
//    [_segControl setFrame:CGRectMake(60, _statusBarHeight, kDeviceWidth - 120, 35)];
//    _segControl.backgroundColor = kGray;
//    [_segControl addTarget:self action:@selector(segContrllChange:) forControlEvents:UIControlEventValueChanged];
//    //    [segControl setTag:1];
//    [self.view addSubview:_segControl];
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
    
    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 35 + _statusBarHeight, kDeviceWidth, 40)];
    mySearchBar.delegate = self;
    [mySearchBar setPlaceholder:@"搜索"];
    [self.view addSubview:mySearchBar];
    
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:mySearchBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    _allData = [[BBDataManager getInstance] getDataList];
    
    [self initLoveListData];

    
    _allView = [[BBStoryTableView alloc] initWithFrame:CGRectMake(0, 75 + _statusBarHeight, kDeviceWidth, kDeviceHeight - 35) Data:_allData];
    _allView.delegate = self;
    [self.view addSubview:_allView];
    
    _loveView = [[BBStoryTableView alloc] initWithFrame:CGRectMake(0, 75 + _statusBarHeight, kDeviceWidth, kDeviceHeight - 35) Data:_loveData];
    _loveView.delegate = self;
    [self.view addSubview:_loveView];
    [_loveView setHidden:YES];
    
    int lastReadPage = (int)[ud integerForKey:[NSString stringWithFormat:@"%@lastReadPage", [[BBDataManager getInstance] getKeyPrefix]]];
    [_allView scrollToRowAtIndexPath:lastReadPage];
    
    [self loadAdBanner];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setDarkMode:[[BBDataManager getInstance] isDarkMode]];
}

- (void)setDarkMode:(BOOL)isDarkMode
{
    [_allView setDarkMode:isDarkMode];
}

- (void)loadAdBanner
{
    
    if (kDeviceWidth > 640) {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeLeaderboard];
    } else {
        _adBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    }
    CGRect frame = _adBannerView.frame;
    _adBannerView.frame = CGRectMake(kDeviceWidth/2 - frame.size.width/2, -frame.size.height, frame.size.width, frame.size.height);
    
    // Specify the ad unit ID.
    _adBannerView.adUnitID = MY_BANNER_UNIT_ID;
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    _adBannerView.rootViewController = self;
    [self.view addSubview:_adBannerView];
    
    // Initiate a generic request to load it with an ad.
    [_adBannerView loadRequest:[GADRequest request]];
}

- (void) initLoveListData
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *loveDic = [ud objectForKey:[NSString stringWithFormat:@"%@loveDic", [[BBDataManager getInstance] getKeyPrefix]]];
    _loveData = [[NSMutableArray alloc] init];
    
    NSArray *keys = [loveDic allKeys];
    int i;
    id key;

    _loveDicCount = (int)[keys count];

    for (i = 0; i < _loveDicCount; i++)
    {
        key = [keys objectAtIndex: i];
        [_loveData addObject:[_allData objectAtIndex:[key intValue]]];
        NSLog (@"Key: %@", key);
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self)
    {
//        // 只有主场景不显示导航条
//        [navigationController setNavigationBarHidden:YES animated:animated];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSDictionary *loveDic = [ud objectForKey:[NSString stringWithFormat:@"%@loveDic", [[BBDataManager getInstance] getKeyPrefix]]];
        
        int count = (int)[[loveDic allKeys] count];
        
        if (count != _loveDicCount) {
            [self initLoveListData];
            [_loveView reloadData:_loveData];
        }
        
        int lastReadPage = (int)[ud integerForKey:[NSString stringWithFormat:@"%@lastReadPage", [[BBDataManager getInstance] getKeyPrefix]]];
        [_allView scrollToRowAtIndexPath:lastReadPage];
    }
    else if ([navigationController isNavigationBarHidden])
    {
//        [navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)segContrllChange:(UISegmentedControl*)seg
{
    NSLog(@"Selected index %li (via UIControlEventValueChanged)", (long)seg.selectedSegmentIndex);
    switch (seg.selectedSegmentIndex)
    {
        case 0:
            [_allView setHidden:NO];
            [_loveView setHidden:YES];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:0];
            break;
            
        case 1:
            [_allView setHidden:YES];
            [_loveView setHidden:NO];
            self.navigationItem.backBarButtonItem.title = [_segTitleArr objectAtIndex:1];
            break;
            
        default:
            break;
    }
}

- (void)pushInfoVCWithData:(NSArray*)data index:(int)index
{
//    BBStoryInfoViewController *infoVC = [[BBStoryInfoViewController alloc] initWithData:data];
    
    BBCycleViewController *infoVC = [[BBCycleViewController alloc] initWithData:data index:index];
    infoVC.drawer = self.drawer;
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int index = [[searchResults objectAtIndex:indexPath.row] intValue];
    cell.textLabel.text = [[_allData objectAtIndex:index] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger index = indexPath.row;
    
    [self pushInfoVCWithData:_allData index:[[searchResults objectAtIndex:index] intValue]];
}

- (NSArray*)getDataArr:(NSArray*)data{
    NSMutableArray *retData = [[NSMutableArray alloc] init];
    for (int i = 0; i < data.count; i++) {
        NSDictionary *v = [data objectAtIndex:i];
        [retData addObject:[v objectForKey:@"title"]];
    }
    return retData;
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSArray *data = _allData;
    
    searchResults = [[NSMutableArray alloc]init];
    if (mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i < data.count; i++) {
            NSString *title = [[data objectAtIndex:i] objectForKey:@"title"];
            if ([ChineseInclude isIncludeChineseInString:title]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:title];
                NSRange titleResult=[tempPinYinStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                    continue;
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
            else {
                NSRange titleResult=[title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
                }
            }
        }
    } else if (mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:mySearchBar.text]) {
        for (int i=0; i < data.count; i++) {
            NSString *title = [[data objectAtIndex:i] objectForKey:@"title"];
            NSRange titleResult=[title rangeOfString:mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:[[data objectAtIndex:i] objectForKey:@"id"]];
            }
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
//    mySearchBar.frame = CGRectMake(0, _statusBarHeight, kDeviceWidth, 40);
    
    searchBar.showsCancelButton = YES;
    for(id cc in [searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    mySearchBar.frame = CGRectMake(0, 35 + _statusBarHeight, kDeviceWidth, 40);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
//    mySearchBar.frame = CGRectMake(0, 35 + _statusBarHeight, kDeviceWidth, 40);
}

- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
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
