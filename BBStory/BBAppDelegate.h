//
//  BBAppDelegate.h
//  BBStory
//
//  Created by FengZi on 14-3-10.
//  Copyright (c) 2014年 FengZi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GADInterstitial.h>
#import "BBNavigationController.h"

#import "GDTSplashAd.h"

@interface BBAppDelegate : UIResponder <UIApplicationDelegate, GADInterstitialDelegate, GDTSplashAdDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)BBNavigationController *navigationController;
@property (strong, nonatomic) GDTSplashAd *splash;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, strong) GADInterstitial *interstitial;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
