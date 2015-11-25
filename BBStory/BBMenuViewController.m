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
#import "BBGamesViewController.h"
#import "BBFunction.h"
#import "BBMainViewController.h"
#import "BBMainNavController.h"
#import "BBRecordListController.h"
#import "BBRecorderNavController.h"
#import "BBNetworkService.h"
#import "BBDataManager.h"
#import "BBBannerManager.h"

static NSString * const kICSColorsViewControllerCellReuseId = @"kICSColorsViewControllerCellReuseId";



@interface BBMenuViewController ()

@property(nonatomic, strong) NSArray *colors;
@property(nonatomic, assign) NSInteger previousRow;

@end



@implementation BBMenuViewController

- (id)initWithColors:(NSArray *)colors
{
    NSParameterAssert(colors);
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _colors = colors;
    }
    return self;
}

- (void)initData
{
    _menuArr = @[@"   小故事", @"   唐诗", @"   我的录音", @"   游乐场", @"   五星好评^_^"];
    _menuImgArr = @[@"menu_smallStory", @"menu_smallStory", @"menu_recorder", @"menu_game", @"menu_rate"];
    _menuImgLightArr = @[@"menu_smallStory_light", @"menu_smallStory_light", @"menu_recorder_light", @"menu_game_light", @"menu_rate_light"];
}

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [self initData];
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:33.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
//    self.view.backgroundColor = [UIColor whiteColor];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kICSColorsViewControllerCellReuseId];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:35/255.0
                                                    green:39/255.0
                                                     blue:48/255.0
                                                    alpha:1
                                     ];
    
    int logoHeightPadding;
    if (kDeviceHeight <= 480.0f) {
        logoHeightPadding = 190;
    } else {
        logoHeightPadding = 230;
    }
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kDeviceHeight - logoHeightPadding, 250, 250)];
    logoView.image = [UIImage imageNamed:@"logo"];
    [logoView setAlpha:0.825f];
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kICSColorsViewControllerCellReuseId
                                                                forIndexPath:indexPath];
        
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
        // Reload the current center view controller and update its background color
//        typeof(self) __weak weakSelf = self;
//        [self.drawer reloadCenterViewControllerUsingBlock:^(){
//            NSParameterAssert(weakSelf.colors);
//            weakSelf.drawer.centerViewController.view.backgroundColor = weakSelf.colors[indexPath.row];
//        }];
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
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setInteger:1 forKey:UD_HAS_SAWNEWGAMES];
                // Replace the current center view controller with a new one
                BBGamesViewController *center = [[BBGamesViewController alloc] init];
//                center.view.backgroundColor = [UIColor redColor];
                [self.drawer replaceCenterViewControllerWithViewController:center];
//                [[BBBannerManager getInstance] showBaitongWall];
            }
                break;
                
            case 4:
                [BBFunction goToAppStoreEvaluate:842439221];
                break;
                
            default:
                break;
        }
        if (row != 4) {
            self.previousRow = row;
            [self.tableView reloadData];
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
