//
//  UIViewController+BBUserViewController.h
//  BBStory
//
//  Created by Fengzi on 15/12/4.
//  Copyright © 2015年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADBannerView.h>
#import "BBCategoryTableView.h"
#import "BBHomeBannerScrollView.h"

@interface BBHomeViewController : UIViewController<UINavigationControllerDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, BBHomeBannerScrollViewDatasource, BBHomeBannerScrollViewDelegate, BBCategoryTableViewDelegate>
{
@private
    float _height;
    BBHomeBannerScrollView *_csView;
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    UIScrollView *_baseView;
    UITableView *_tableView1;
    UITableView *_tableView2;
    GADBannerView *_adBannerView;
    GADBannerView *_adSquareBannerView;
}

@end
