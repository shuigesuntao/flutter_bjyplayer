//
//  WXPlayOptionsManager.h
//  WXOnlineSchool
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BJPUVideoOptions.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXPlayOptionsManager : NSObject
#pragma mark - BJPUVideoOptions 点播设置

+ (void)setVideoOptions:(BJPUVideoOptions *)videoOptions;

+ (BJPUVideoOptions *)getVideoOptions;



@end

NS_ASSUME_NONNULL_END
