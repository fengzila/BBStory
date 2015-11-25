//
//  BBCycleViewController.h
//  BBStory
//
//  Created by FengZi on 14-3-13.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBCycleScrollView.h"
#import "BBCycleScrollCell.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "BBInfoSettingView.h"
#import "BBDoRecordingView.h"
#import "ICSDrawerController.h"

@interface BBCycleViewController : UIViewController<ICSDrawerControllerChild, ICSDrawerControllerPresenting, BBCycleScrollViewDatasource, BBCycleScrollViewDelegate, BBCycleScrollCellDelegate, BBInfoSettingViewDelegate>
{
@private
    NSArray* _data;
    int _lastPosition;
    BOOL _tabbarIsHidden;
    int _index;
    int _statusHeight;
    
    UIView *_listView;
    BBCycleScrollView *_csView;
    UIButton *_recordingBtn;
    UIButton *_loveBtn;
    UIButton *_moreBtn;
    UILabel *_pageLabel;
    UIImageView *_tabbarLine;
    
    UIView *_tabbarView;
    GADBannerView *_adBannerView;
    
    BBInfoSettingView *_infoSettingView;
    BBDoRecordingView *_doRecordingView;
}
@property(nonatomic, weak) ICSDrawerController *drawer;
- (id)initWithData:(NSArray*)data index:(int)index;
@end
