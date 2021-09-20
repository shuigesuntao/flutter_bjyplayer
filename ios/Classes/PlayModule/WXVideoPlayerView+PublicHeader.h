//
//  BJYPlayerView+PublicHeader.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "BJPUMediaControlView.h"
#import "BJPUMediaSettingView.h"
#import "BJPUSliderView.h"
#import "BJPUReloadView.h"
#import "WXVideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoPlayerView()

@property (nonatomic, strong,nullable) BJVPlayerManager *playerManager;
@property (nonatomic, strong) BJPUVideoOptions *videoOptions;
@property (nonatomic, strong) BJLAFNetworkReachabilityManager *reachablityManager;

@property (nonatomic, strong) BJPUMediaControlView *mediaControlView;
@property (nonatomic, strong) BJPUMediaSettingView *mediaSettingView;
@property (nonatomic, strong) BJPUSliderView *sliderView;
@property (nonatomic, strong) UIImageView *audioOnlyImageView;
@property (nonatomic, strong) UIView *topBarView;
@property (nonatomic, strong) UIButton *lockButton;
@property (nonatomic, strong) BJPUReloadView *reloadView;

@property (nonatomic, nullable) NSString *videoID, *token;
@property (nonatomic, nullable) BJVDownloadItem *downloadItem;
@property (nonatomic, nullable) NSTimer *updateDurationTimer;
@property (nonatomic) NSArray *currentOptions;
@property (nonatomic) NSArray *rateList;
@property (nonatomic, assign) NSUInteger rateIndex;
@property (nonatomic, assign) NSUInteger definitionIndex;
//播放累计时间
@property (nonatomic, assign) NSInteger playCumulativeTime;
@property(nonatomic,assign) BOOL needRecodTime;
@property (nonatomic) BOOL isPlayingTailAD, isLocalVideo, pauseByInterrupt;


@end
NS_ASSUME_NONNULL_END

