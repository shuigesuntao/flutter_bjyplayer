//
//  WXFloatPlayerView.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXVideoPlayerView,BJVDownloadItem;
NS_ASSUME_NONNULL_BEGIN

@interface WXFloatPlayerView : UIView

+ (instancetype)shareFloatPlayerView;

@property (nonatomic, strong) NSString *chapterID;
// 未正在播放在线视频播放
- (void)showInWindowWithPlayWithVid:(NSString *)vid token:(NSString *)token;

// 正在播放在线视频播放
- (void)showInWindowFromVideoPlayer:(WXVideoPlayerView *)videoPlayer;

// 未正在播放本地视频播放
- (void)showInWindowWithDownloadItem:(BJVDownloadItem *)downloadItem;

- (void)destroyFloatVideoPlayerView;

@end

NS_ASSUME_NONNULL_END
