//
//  BBDataManager.m
//  BBStory
//
//  Created by Fengzi on 15/9/5.
//  Copyright (c) 2015年 FengZi. All rights reserved.
//
#import "BBRecorderObject.h"

@implementation BBRecorderObject

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_recorderId forKey:@"recorderId"];
    [encoder encodeObject:_name forKey:@"name"];
    [encoder encodeObject:_time forKey:@"time"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        _recorderId = [decoder decodeObjectForKey:@"recorderId"];
        _name = [decoder decodeObjectForKey:@"name"];
        _time = [decoder decodeObjectForKey:@"time"];
    }
    return self;
}

@end