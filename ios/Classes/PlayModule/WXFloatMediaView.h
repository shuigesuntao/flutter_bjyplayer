//
//  WXFloatMediaView.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import <UIKit/UIKit.h>

static const NSInteger BJY_voiceViewTag = 100806;
#import "BJPUViewController.h"

@interface WXFloatMediaView : UIView

+ (instancetype)sharetMediaView;

@property (strong, nonatomic) BJPUViewController *playerUIVC;

/**
 展示按钮
 */
- (void)showAnimation;

/**
 隐藏按钮
 */
- (void)removeViewAnimation;

@end

@interface BJYFloatMediaManager : NSObject

/**
 显示播放器
 */
+ (void)bjy_showVoiceView;

/**
 隐藏播放器
 */
+ (void)bjy_hiddenVoiceView;

/**
 移除播放器以及播放源
 */
+ (void)bjy_removeVoiceView;


@end

