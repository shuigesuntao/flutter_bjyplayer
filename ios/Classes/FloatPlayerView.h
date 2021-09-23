//
//  FloatPlayerView.h
//  flutter_bjyplayer
//
//  Created by 刘厚宽 on 2021/9/23.
//

#import <UIKit/UIKit.h>
#import <BJVideoPlayerUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface FloatPlayerView : UIView

+ (instancetype)shareFloatPlayerView;

@property (nonatomic, strong) NSString *chapterID;
// 未正在播放在线视频播放
- (void)showInWindowWithPlayWithVid:(NSString *)vid token:(NSString *)token;

// 正在播放在线视频播放
- (void)showInWindowFromVideoPlayer:(BJPUViewController  *)playerVC;

// 未正在播放本地视频播放
//- (void)showInWindowWithDownloadItem:(BJVDownloadItem *)downloadItem;

- (void)destroyFloatVideoPlayerView;
@end

NS_ASSUME_NONNULL_END
