//
//  BBDataManager.m
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//
#import "BBDataManager.h"
#import "BBNetworkService.h"

@implementation BBDataManager
+ (id)getInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

-(id)init
{
    self = [super init];
    if (self) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _contentFontSize = (int)[ud integerForKey:@"contentFontSize"];
        if (_contentFontSize == 0) {
            _contentFontSize = 100;
        }
        _isDarkMode = [ud boolForKey:@"isDarkMode"];
        
        _categoryDataList = [[NSMutableArray alloc] init];
        [_categoryDataList addObject:@{@"img" : @"category_1", @"title" : @"小故事", @"num" : @"280", @"recordKey" : @"recorderStoryList", @"recordPrefix" : @"story", @"dataKey" : @"storyList", @"keyPrefix" : @""}];
        [_categoryDataList addObject:@{@"img" : @"category_2", @"title" : @"唐诗三百首", @"num" : @"313", @"recordKey" : @"recorderTangshiList", @"recordPrefix" : @"tangshi", @"dataKey" : @"tangshilist", @"keyPrefix" : @"tangshi"}];
        [_categoryDataList addObject:@{@"img" : @"category_3", @"title" : @"安徒生童话", @"num" : @"133", @"recordKey" : @"recorderAndersenList", @"recordPrefix" : @"andersen", @"dataKey" : @"andersenList", @"keyPrefix" : @"andersen"}];
        [_categoryDataList addObject:@{@"img" : @"category_4", @"title" : @"格林童话", @"num" : @"193", @"recordKey" : @"recorderGrimmList", @"recordPrefix" : @"grimm", @"dataKey" : @"grimmList", @"keyPrefix" : @"grimm"}];
    }
    
    return self;
}

-(void)setCurContentDataType:(ContentDataType)DataType
{
    _contentDataType = DataType;
}

-(ContentDataType)getCurContentDataType
{
    return _contentDataType;
}

-(id)getDataList
{
    switch ([[BBDataManager getInstance] getCurContentDataType]) {
        case kContentDataTypeStory:
            return [BBNetworkService storyList:@"storyList"];
            break;
        case kContentDataTypeTangshi:
            return [BBNetworkService tangshiList:@"tangshilist"];
            break;
            
        default:
            break;
    }
    return nil;
}

-(id)getDataListWithKey:(NSString*)key
{
    NSArray *items = @[@"storyList", @"tangshilist", @"andersenList", @"grimmList", @"tangshilist"];
    int item = (int)[items indexOfObject:key];
    switch (item) {
        case 0:
            return [BBNetworkService storyList:@"storyList"];
            break;
        case 1:
            return [BBNetworkService tangshiList:@"tangshilist"];
            break;
        case 2:
            return [BBNetworkService andersenList:@"andersenList"];
            break;
        case 3:
            return [BBNetworkService grimmList:@"grimmList"];
            break;
            
        default:
            break;
    }
    return nil;
}

-(NSString*)getKeyPrefix
{
    switch ([[BBDataManager getInstance] getCurContentDataType]) {
        case kContentDataTypeStory:
            return @"";
            break;
        case kContentDataTypeTangshi:
            return @"tangshi";
            break;
            
        default:
            break;
    }
    return nil;
}

-(void)changeColor
{
    _tapNum++;
}

-(int)getColorIndex
{
    return _tapNum;
}

-(void)setIsDarkMode:(BOOL)isDarkMode
{
    _isDarkMode = isDarkMode;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:isDarkMode forKey:@"isDarkMode"];
}

-(BOOL)isDarkMode
{
    return _isDarkMode;
}

-(void)setContentFontSize:(int)fontSize;
{
    _contentFontSize = fontSize;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:fontSize forKey:@"contentFontSize"];
}

-(int)getContentFontSize
{
    return _contentFontSize;
}

-(void)setDrawer:(ICSDrawerController*)drawer
{
    _drawer = drawer;
}

-(ICSDrawerController*)getDrawer
{
    return _drawer;
}

-(NSMutableArray*)getCategoryDataList
{
    return _categoryDataList;
}
@end