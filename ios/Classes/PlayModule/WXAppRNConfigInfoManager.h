//
//  WXAppRNConfigInfoManager.h
//  ZYWXOnlineSchool
//
//  Created by mac on 2020/6/24.
//  Copyright © 2020 JackMac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXAppRNConfigInfoManager : NSObject

///保存qq 微信 temp 登录配置
+ (BOOL)saveLoginOauthInfo:(NSDictionary *)userOauthInfo;

+ (NSDictionary *)getAppConfigSettingInfo:(NSString *)configSettingKey;

+ (BOOL)clearLoginOauthInfo;

///保存qq 微信 temp 分享配置
+ (BOOL)saveShareInfo:(NSDictionary *)userShareInfo;

+ (BOOL)clearShareInfo;

///保存一对一 下载 优惠券 学习卡等开关配置
+ (BOOL)saveAppBaseInfo:(NSDictionary *)userAppBaseInfo;

+ (BOOL)clearAppBaseInfo;

///保存其他开关配置
+ (BOOL)saveOtherInfo:(NSDictionary *)userOtherInfo;

+ (BOOL)clearOtherInfo;

///保存系统配置
+ (BOOL)saveSystemInfo:(NSDictionary *)userSystemInfo;

+ (BOOL)clearSystemInfo;

///保存公共配置
+ (BOOL)saveCommonSettingInfo:(NSDictionary *)userCommonSettingInfo;

+ (BOOL)clearCommonSettingInfo;

///保存分校信息
+ (BOOL)saveAppSchoolInfo:(NSDictionary *)userCommonSettingInfo;

+ (BOOL)clearAppSchoolInfo;

///下载 课程
+ (BOOL)saveCourseInfo:(NSDictionary *)userInfo;

+ (BOOL)clearCourseInfo;

@end

NS_ASSUME_NONNULL_END
