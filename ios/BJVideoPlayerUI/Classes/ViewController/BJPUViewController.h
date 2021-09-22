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
///转屏 通知
@property (nonatomic, copy) void (^screenDeviceOrientationDidChange)(BOOL fullScreen);


- (instancetype)initWithVideoOptions:(BJPUVideoOptions *)videoOptions;

// 在线视频播放
- (void)playWithVid:(NSString *)vid token:(NSString *)token;

// 本地视频播放
- (void)playWithDownloadItem:(BJVDownloadItem *)downloadItem;

@end
