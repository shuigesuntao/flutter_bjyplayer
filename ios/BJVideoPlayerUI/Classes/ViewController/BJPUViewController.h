//
//  BJPUViewController.h
//  BJVideoPlayerUI
//
//  Created by DLM on 2017/4/26.
//
//

#import <UIKit/UIKit.h>
#import <BJVideoPlayerCore/BJVideoPlayerCore.h>
#import "BJPUVideoOptions.h"

typedef NS_ENUM(NSUInteger, BJVPlayerViewLayoutType) {
    BJVPlayerViewLayoutType_Vertical,
    BJVPlayerViewLayoutType_Horizon
};

typedef NS_ENUM(NSUInteger, BJVPlayerViewScreenType) {
    BJVPlayerViewScreenNormalType = 1,//正常
    BJVPlayerViewScreenFullScreenType = 2,//全屏
};

@interface BJPUViewController : UIViewController

@property (nonatomic, assign) BJVPlayerViewLayoutType layoutType;
@property (nonatomic, assign) BJVPlayerViewScreenType playType;
@property (nonatomic, copy) void (^cancelCallback)(void);
@property (nonatomic, copy) void (^screenLockCallback)(BOOL locked);
@property (nonatomic, copy) void (^progressBlock)(NSTimeInterval currentTime,NSTimeInterval duration);

///转屏 通知
@property (nonatomic, copy) void (^screenDeviceOrientationDidChange)(BOOL fullScreen);


- (instancetype)initWithVideoOptions:(BJPUVideoOptions *)videoOptions;

// 在线视频播放
- (void)playWithVid:(NSString *)vid token:(NSString *)token;

// 本地视频播放
- (void)playWithDownloadItem:(BJVDownloadItem *)downloadItem;

/************************与flutter定义的方法*********************************/


///销毁
- (void)ExecuteReleased;
///是否销毁
- (BOOL)IsReleased;
///开始播放
- (void)ExecutePlay;
///暂停后播放
- (void)ExecutePause;
///暂停
- (void)ExecuteStop;
///重新播放
- (void)ExecuteRePlay;
///跳转到时间
- (void)ExecuteSeekWitTime:(NSNumber *)time;
///是否正在播放
- (BOOL)isPlaying;
///隐藏返回按钮
- (void)ExecuteHideBackIcon:(BOOL)isHidden;
///隐藏bottom bar
- (void)ExecuteHideBootomBar:(BOOL)isHidden;
///重置监听
- (void)ExecuteSetupObservers;
@end
