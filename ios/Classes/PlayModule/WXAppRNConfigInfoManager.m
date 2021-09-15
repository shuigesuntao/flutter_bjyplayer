//
//  WXAppRNConfigInfoManager.m
//  ZYWXOnlineSchool
//
//  Created by mac on 2020/6/24.
//  Copyright © 2020 JackMac. All rights reserved.
//

#import "WXAppRNConfigInfoManager.h"

static NSString *kOauthPlist = @"oauth.plist";
static NSString *kSharePlist = @"share.plist";
static NSString *kApp_basePlist = @"app_base.plist";
//存储分校
static NSString *kApp_schoolPlist = @"school.plist";
//其他开关配置
static NSString *kAotherPlist = @"other.plist";
//登录系统配置
static NSString *kSystemPlist = @"system.plist";
//公共配置
static NSString *kCommon_settingPlist = @"common_setting.plist";

static NSString *kCoursePlist = @"course.plist";

@implementation WXAppRNConfigInfoManager

+ (NSString *)wxDocumentsPath
{
    static dispatch_once_t onceToken;
    static NSString *documentsPath;
    dispatch_once(&onceToken, ^{
        documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    });

    return documentsPath;
}

+ (BOOL)removeFile:(NSString *)filePath {
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
       return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    return YES;
}

+ (NSDictionary *)getAppConfigSettingInfo:(NSString *)configSettingKey{
    if ([kSystemPlist containsString:configSettingKey]) {
        return [self getConfigSettingInfo:kSystemPlist];
    }else if ([kOauthPlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kOauthPlist];;
    }else if ([kAotherPlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kAotherPlist];;
    }else if ([kApp_basePlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kApp_basePlist];;
    }else if ([kSharePlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kSharePlist];;
    }else if ([kCommon_settingPlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kCommon_settingPlist];;
    }else if ([kApp_schoolPlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kApp_schoolPlist];;
    }else if ([kCoursePlist containsString:configSettingKey]){
        return [self getConfigSettingInfo:kCoursePlist];;
    }else{
        return @{};
    }
}

+ (NSDictionary *)getConfigSettingInfo:(NSString *)pathPlist{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:pathPlist];
    NSDictionary *configInfo = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return configInfo;
}

///保存qq 微信 temp 登录配置
+ (BOOL)saveLoginOauthInfo:(NSDictionary *)userOauthInfo{
    
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kOauthPlist];
    return [userOauthInfo writeToFile:filePath atomically:YES];
}

+ (BOOL)clearLoginOauthInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kOauthPlist];
    return [self removeFile:filePath];
}

///保存qq 微信 temp 分享配置
+ (BOOL)saveShareInfo:(NSDictionary *)userShareInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kSharePlist];
    return [userShareInfo writeToFile:filePath atomically:YES];
}

+ (BOOL)clearShareInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kSharePlist];
    return [self removeFile:filePath];
}

///保存一对一 下载 优惠券 学习卡等开关配置
+ (BOOL)saveAppBaseInfo:(NSDictionary *)userAppBaseInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kApp_basePlist];
    return [userAppBaseInfo writeToFile:filePath atomically:YES];
}

+ (BOOL)clearAppBaseInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kApp_basePlist];
    return [self removeFile:filePath];
}

///保存其他开关配置
+ (BOOL)saveOtherInfo:(NSDictionary *)userOtherInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kAotherPlist];
    return [userOtherInfo writeToFile:filePath atomically:YES];
}


+ (BOOL)clearOtherInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kAotherPlist];
    return [self removeFile:filePath];
}


///保存系统配置
+ (BOOL)saveSystemInfo:(NSDictionary *)userSystemInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kSystemPlist];
    return [userSystemInfo writeToFile:filePath atomically:YES];
}


+ (BOOL)clearSystemInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kSystemPlist];
    return [self removeFile:filePath];
}


///保存公共配置
+ (BOOL)saveCommonSettingInfo:(NSDictionary *)userCommonSettingInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kCommon_settingPlist];
    return [userCommonSettingInfo writeToFile:filePath atomically:YES];
}

+ (BOOL)clearCommonSettingInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kCommon_settingPlist];
    return [self removeFile:filePath];
}



///保存分校信息
+ (BOOL)saveAppSchoolInfo:(NSDictionary *)userCommonSettingInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kApp_schoolPlist];
    return [userCommonSettingInfo writeToFile:filePath atomically:YES];
}


+ (BOOL)clearAppSchoolInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kApp_schoolPlist];
    return [self removeFile:filePath];
}

+ (BOOL)saveCourseInfo:(NSDictionary *)userInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kCoursePlist];
    return [userInfo writeToFile:filePath atomically:YES];
}

+ (BOOL)clearCourseInfo{
    NSString *filePath = [[self wxDocumentsPath] stringByAppendingPathComponent:kCoursePlist];
    return [self removeFile:filePath];
}

@end
