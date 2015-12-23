//
//  BBMainViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-11.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBStoryTableView.h"
#import "ICSDrawerController.h"
#import "BBSegmentedControl.h"
#import <GoogleMobileAds/GADBannerView.h>

@interface BBMainViewController : UIViewController<BBStoryTableViewDelegate, UINavigationControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource,UITableViewDelegate, ICSDrawerControllerChild, ICSDrawerControllerPresenting>
{
@private
    NSDictionary *_configData;
    BBStoryTableView *_allView;
    BBStoryTableView *_loveView;
    
    UISearchBar *mySearchBar;
    UISearchDisplayController *searchDisplayController;
//    BBSegmentedControl *_segControl;
    UISegmentedControl *_segControl;
    
    NSInteger _lastPosition;
    BOOL _tabbarIsHidden;
    
    int _statusBarHeight;
    
    NSArray *_segTitleArr;
    NSMutableArray *searchResults;
    NSArray *_allData;
    NSMutableArray *_loveData;
    
    int _loveDicCount;
    GADBannerView *_adBannerView;
}

@property(nonatomic, weak) ICSDrawerController *drawer;

- (id)initWithData:(NSDictionary*)data;

@end
