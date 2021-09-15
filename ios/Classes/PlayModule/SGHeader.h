//
//  SGHeader.h
//  post
//
//  Created by liu chao on 15/10/8.
//  Copyright (c) 2015年 liu chao. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * kSGHeaderToken;

@interface SGHeader : NSObject
///token
@property (nonatomic,copy) NSString *Authorization;
///设备ID
@property (nonatomic,copy) NSString * DeviceId;
///平台 ios 或 android
@property (nonatomic,copy) NSString * DeviceType;

@property (nonatomic,copy) NSString * SchoolId;

+ (NSString *)getSchoolID;

@end
