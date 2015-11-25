
//
//  BBDataManager.h
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kContentDataTypeStory = 0,
    kContentDataTypeTangshi
}ContentDataType;

@interface BBDataManager : NSObject{
@private
    ContentDataType _contentDataType;
    int _tapNum;
    BOOL _isDarkMode;
    int _contentFontSize;
}


+(BBDataManager *)getInstance;
-(void)setCurContentDataType:(ContentDataType)DataType;
-(ContentDataType)getCurContentDataType;
-(id)getDataList;
-(NSString*)getKeyPrefix;
-(void)changeColor;
-(int)getColorIndex;
-(void)setIsDarkMode:(BOOL)isDarkMode;
-(BOOL)isDarkMode;
-(void)setContentFontSize:(int)fontSize;
-(int)getContentFontSize;
@end