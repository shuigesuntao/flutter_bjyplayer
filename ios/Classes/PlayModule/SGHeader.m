//
//  SGHeader.m
//  post
//
//  Created by liu chao on 15/10/8.
//  Copyright (c) 2015年 liu chao. All rights reserved.
//  UUIDString = F483521B-8661-4781-A4DA-DCFA147DDEA9

#import "SGHeader.h"
#import "NSString+JSON.h"
#import "WXAppRNConfigInfoManager.h"
#import <UIKit/UIKit.h>

NSString *kSGHeaderToken = @"zywxtoken";
#define UserFilePath [NSTemporaryDirectory() stringByAppendingPathComponent:@"userinfo.data"]

//9.加密密钥
@implementation SGHeader

- (NSString *)Authorization
{
    id userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:UserFilePath];
    if (userInfo == nil || [userInfo isKindOfClass:[NSNull class]]) {
        return @"";
    }
    NSString *remember_token = [userInfo valueForKey:@"remember_token"];
    if (![self isBlankString:remember_token])
    {
        return [NSString stringWithFormat:@"Bearer %@",remember_token];
    }
    return @"";
}

- (NSString *)DeviceType{
    return @"IOS";
}

+ (NSString *)getSchoolID{
    id userInfo = [WXAppRNConfigInfoManager getAppConfigSettingInfo:@"school"];
    if (userInfo == nil || [userInfo isKindOfClass:[NSNull class]]) {
        return @"0";
    }
    NSString *school_id = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"school_id"]];
    return school_id;
}

- (NSString *)SchoolId{
    id userInfo = [WXAppRNConfigInfoManager getAppConfigSettingInfo:@"school"];
    if (userInfo == nil || [userInfo isKindOfClass:[NSNull class]]) {
        return @"0";
    }
    NSString *school_id = [NSString stringWithFormat:@"%@",[userInfo valueForKey:@"school_id"]];
    if (![self isBlankString:school_id])
    {
        return school_id;
    }
    return @"";
}

- (BOOL)isBlankString:(NSString *)aStr {
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (!aStr.length) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

@end
