//
//  BJYPlayerView.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BJPUVideoOptions.h"
#import "Helper.h"
typedef NS_ENUM(NSUInteger, BJYPlayerViewLayoutType) {
    BJYPlayerViewLayoutType_Vertical = 1,
    BJYPlayerViewLayoutType_FullHorizon = 2
};

typedef NS_ENUM(NSUInteger, BJYPlayerViewScreenType) {
    BJYPlayerViewScreenNormalType = 1,//正常
    BJYPlayerViewScreenFullScreenType = 2,//全屏
    BJYPlayerViewScreenSimpleType = 3//悬浮 无UI 只有播放View
};

///录播课播放 1：继续播放下节 2：暂停 3：循环播放
UIKIT_EXTERN NSString *ApprecordedResponseEvent;

#define is_IPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define kIphoneStatusHeight \
({CGFloat statusBarHeight = 0.0;\
if (@available(iOS 13.0, *)) {\
statusBarHeight = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarFrame.size.height;\
} else { \
statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;\
}\
(statusBarHeight);\
})

//判断iPhone5系列
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !is_IPad : NO)
//判断iPhone6系列
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !is_IPad : NO)
//判断iphone6+系列
#define iPhone7plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !is_IPad : NO)
//判断iPhoneX
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !is_IPad : NO)
/// 是否全面屏设备
#define IS_Full_SCREEN (([[UIApplication sharedApplication] statusBarFrame].size.height > 20) ?  YES : NO)

// 状态栏高度
#define STATUS_BAR_HEIGHT  (is_IPad ? (IS_Full_SCREEN ? 24 : 20) : kIphoneStatusHeight)
// 导航栏高度
#define NAVIGATION_BAR_HEIGHT (is_IPad ? (IS_Full_SCREEN ? 68 : 64) : (kIphoneStatusHeight + 44))
// tabBar高度
#define TAB_BAR_HEIGHT (is_IPad ? (IS_Full_SCREEN ? 65.0 : 50.0) : (kIs_iPhoneX ? 83.0 : 49.0))
// home indicator
#define HOME_INDICATOR_HEIGHT (is_IPad ? (IS_Full_SCREEN ? 20.0 : 0.0) : (kIs_iPhoneX ? 34.0 : 0.0))

@protocol WXVideoPlayerViewDelegate <NSObject>

@optional
- (void)getVideoPlayerWithPlayCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration;
- (void)getVideoBJVPlayerStatus:(BJVPlayerStatus)status;

@end

@interface WXVideoPlayerView : UIView

@property (nonatomic, assign) BJYPlayerViewLayoutType layoutType;
///播放类型
@property (nonatomic, assign) BJYPlayerViewScreenType playType;
///禁止旋转
@property (nonatomic, assign) BOOL isForbidRotate;
///是否全屏
@property (nonatomic, assign) BOOL isFullscreen;
///是否锁屏
@property (nonatomic, assign) BOOL isLockscreen;
///是否手动旋转
@property (nonatomic, assign) BOOL manualRotation;
///back 关闭按钮事件
@property (nonatomic, copy) void (^cancelCallback)(void);
///锁屏按钮事件
@property (nonatomic, copy) void (^screenLockCallback)(BOOL locked);

@property (nonatomic, weak) id<WXVideoPlayerViewDelegate> playerDelegate;
///转屏 通知
@property (nonatomic, copy) void (^screenDeviceOrientationDidChange)(BOOL fullScreen,UIInterfaceOrientation interfaceOrientation);

- (void)configLayoutType:(BJYPlayerViewLayoutType)layoutType;
///创建初始化
- (instancetype)initWithFrame:(CGRect)frame videoOptions:(BJPUVideoOptions *)videoOptions surperView:(UIView *)surperView playerViewScreenType:(BJYPlayerViewScreenType)playerViewScreenType;

// 在线视频播放
- (void)playWithVid:(NSString *)vid token:(NSString *)token;

// 本地视频播放
- (void)playWithDownloadItem:(BJVDownloadItem *)downloadItem;

///移除 暂停播放器
- (void)removeAndPauseVideoPlayerView;
///重置清空播放器
- (void)resetVideoPlayerView;
///继续播放
- (void)continuePlay;
///销毁播放器
- (void)destroyVideoPlayerView;

@end

