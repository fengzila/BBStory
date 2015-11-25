
//
//  BBDataManager.h
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBRecorderObject : NSObject{
@private
    NSNumber *_recorderId;
    NSString *_name;
    NSString *_time;
}
@property(nonatomic)NSNumber* recorderId;
@property(nonatomic)NSString* name;
@property(nonatomic)NSString* time;
@end
