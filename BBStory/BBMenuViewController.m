//
//  ICSColorsViewController.m
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

#import "BBMenuViewController.h"
#import "BBFunction.h"
#import "BBMainViewController.h"
#import "BBMainNavController.h"
#import "BBRecordListController.h"
#import "BBRecorderNavController.h"
#import "BBNetworkService.h"
#import "BBDataManager.h"
#import "BBBannerManager.h"
#import "MobClick.h"
#import "BBFindNavController.h"
#import "BBFindController.h"

static NSString * const kICSColorsViewControllerCellReuseId = @"kICSColorsViewControllerCellReuseId";



@interface BBMenuViewController ()

@property(nonatomic, assign) NSInteger previousRow;

@end



@implementation BBMenuViewController

- (void)initData
{
    _menuArr = @[@"   小故事", @"   唐诗", @"   我的录音", @"   发现", @"   五星好评^_^"];
    _menuImgArr = @[@"menu_smallStory", @"menu_smallStory", @"menu_recorder", @"menu_game", @"menu_rate"];
    _menuImgLightArr = @[@"menu_smallStory_light", @"menu_smallStory_light", @"menu_recorder_light", @"menu_game_light", @"menu_rate_light"];
}

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [self initData];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRed:35/255.0
                                                    green:39/255.0
                                                     blue:48/255.0
                                                    alpha:1
                                     ];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 250, 153)];
    logoView.image = [UIImage imageNamed:@"logo"];
//    [logoView setAlpha:0.825f];
    [self.view addSubview:logoView];
}

#pragma mark - Configuring the view’s layout behavior

- (UIStatusBarStyle)preferredStatusBarStyle
{
    // Even if this view controller hides the status bar, implementing this method is still needed to match the center view controller's
    // status bar style to avoid a flicker when the drawer is dragged and then left to open.
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    
    if(section == 0)
    {
        static NSString *CellWithIdentifier = @"localCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = [_menuArr objectAtIndex:row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:25.0f/255.0f green:28.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        cell.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:32.0f/255.0f blue:39.0f/255.0f alpha:1.0f];
        
        if (row == 3) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSInteger hasSawNewGames = [ud integerForKey:UD_HAS_SAWNEWGAMES];
            if (!hasSawNewGames)
            {
                UIImageView *tipsView = [[UIImageView alloc] initWithFrame:CGRectMake(180, 22, 10, 10)];
                tipsView.image = [UIImage imageNamed:@"tips"];
                [cell addSubview:tipsView];
            }
        }
        
        if (self.previousRow == row) {
            cell.textLabel.textColor = [UIColor colorWithRed:255/255.0 green:70/255.0 blue:51/255.0 alpha:1];
            cell.imageView.image = [UIImage imageNamed:[_menuImgLightArr objectAtIndex:row]];
        } else {
            cell.imageView.image = [UIImage imageNamed:[_menuImgArr objectAtIndex:row]];
        }
//        CGSize itemSize = CGSizeMake(20, 20);
//        
//        UIGraphicsBeginImageContext(itemSize);
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//        [cell.imageView.image drawInRect:imageRect];
//        
//
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        
//        UIGraphicsEndImageContext();
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
//    NSUInteger section = [indexPath section];
    
    if (row == self.previousRow) {
        // Close the drawer without no further actions on the center view controller
        [self.drawer close];
    }
    else {
        switch (row) {
            case 0:
            {
                [[BBDataManager getInstance] setCurContentDataType:kContentDataTypeStory];
                BBMainViewController *mainVC = [[BBMainViewController alloc] init];
                mainVC.drawer = self.drawer;
                BBMainNavController *navigation = [[BBMainNavController alloc] initWithRootViewController:mainVC];
                [self.drawer replaceCenterViewControllerWithViewController:navigation];
            }
                break;
            case 1:
            {
                [[BBDataManager getInstance] setCurContentDataType:kContentDataTypeTangshi];
                BBMainViewController *mainVC = [[BBMainViewController alloc] init];
                mainVC.drawer = self.drawer;
                BBMainNavController *navigation = [[BBMainNavController alloc] initWithRootViewController:mainVC];
                [self.drawer replaceCenterViewControllerWithViewController:navigation];
            }
                break;
            case 2:
            {
                BBRecordListController *recordListVC = [[BBRecordListController alloc] init];
                recordListVC.drawer = self.drawer;
                BBRecorderNavController *navigation = [[BBRecorderNavController alloc] initWithRootViewController:recordListVC];
                [self.drawer replaceCenterViewControllerWithViewController:navigation];
            }
                break;
                
            case 3:
            {
//                UINavigationController *communityViewController = [UMCommunity getFeedsModalViewController];
//                [self.drawer replaceCenterViewControllerWithViewController:communityViewController];
                BBFindController *findVC = [[BBFindController alloc] init];
                BBFindNavController *navigation = [[BBFindNavController alloc] initWithRootViewController:findVC];
                [self.drawer replaceCenterViewControllerWithViewController:navigation];
            }
                break;
                
            case 4:
                [MobClick event:@"btn_menu_rate"];
                [BBFunction goToAppStoreEvaluate:842439221];
                break;
                
            default:
                break;
        }
        if (row != 4) {
            self.previousRow = row;
            [_tableView reloadData];
        }
    }
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

@end
