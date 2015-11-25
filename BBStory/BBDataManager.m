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
@end