//
//  BjyPlayerView.m
//  Pods
//
//  Created by Sun on 2021/9/5.
//

#import "BjyPlayerView.h"
#import <BJVideoPlayerUI.h>
#import "FloatPlayerView.h"
#import "BjyPlayerEventSinkQueue.h"

@interface BjyPlayerView ()<FlutterStreamHandler,BJVRequestTokenDelegate>

@property (nonatomic, strong) BJPUViewController *playerUIVC;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
//UIKIT_EXTERN NSString *BJYRequestToken;
///是否隐藏状态栏
@property (nonatomic, assign) BOOL currentStatusBarHidden;
@end

@implementation BjyPlayerView{
    BjyPlayerEventSinkQueue *_eventSink;
}

+ (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args registrar:(id<FlutterPluginRegistrar>)registrar{
    BjyPlayerView *playerView = [[BjyPlayerView alloc] initWithRegistrar:registrar viewIdentifier:viewId];
    return playerView;
}

- (instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar viewIdentifier:(int64_t)viewId{
    if (self = [self init]) {
        __weak typeof(self) weakSelf = self;
        // 初始化
        _eventSink = [BjyPlayerEventSinkQueue new];
       
        [BJVideoPlayerCore setTokenDelegate:self];
        BJPUVideoOptions *options = [BJPUVideoOptions new];
        options.autoplay = YES;
        options.playerType = BJVPlayerType_IJKPlayer;
        //options.backgroundAudioEnabled = YES;
        options.preferredDefinitionList = @[@"superHD", @"high", @"720p", @"1080p",@"low"];
        options.playTimeRecordEnabled = YES;
        options.encryptEnabled = NO;
        options.initialPlayTime = 0;
        options.userName = @"";
        options.userNumber = 0;
        options.playerType = BJVPlayerType_IJKPlayer;

        self.playerUIVC = [[BJPUViewController alloc] initWithVideoOptions:options];
        // 退出回调
        [self.playerUIVC setCancelCallback:^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;

        }];
        
        
        // 锁屏回调
        [self.playerUIVC setScreenLockCallback:^(BOOL locked) {

            
        }];
        //横屏回调
        self.playerUIVC.screenDeviceOrientationDidChange = ^(BOOL fullScreen) {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf onToggleScreen:fullScreen];
        };

        // 移除悬浮窗

        FloatPlayerView *floatPlayerView = [FloatPlayerView shareFloatPlayerView];
        [floatPlayerView destroyFloatVideoPlayerView];
//        [floatPlayerView showInWindowFromVideoPlayer:self.playerUIVC];
        // 设置监听
        _methodChannel = [FlutterMethodChannel methodChannelWithName:[@"plugin.bjyPlayer_" stringByAppendingString:[NSString stringWithFormat:@"%@", @(viewId)]] binaryMessenger:[registrar messenger]];
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [weakSelf handleMethodCall:call result:result];
        }];

        _eventChannel = [FlutterEventChannel eventChannelWithName:[@"plugin.bjyPlayer_event_" stringByAppendingString:[NSString stringWithFormat:@"%@", @(viewId)]] binaryMessenger:[registrar messenger]];
        [_eventChannel setStreamHandler:self];
        
        [self.playerFatherView addSubview:self.playerUIVC.view];
        self.playerUIVC.view.frame = self.playerFatherView.frame;
    }
    
    return self;
}

#pragma mark - <BJVRequestTokenDelegate>

//- (void)requestTokenWithVideoID:(NSString *)videoID
//                     completion:(void (^)(NSString * _Nullable token, NSError * _Nullable error))completion {
//    NSString *key = videoID ?: @"";
//    
//    completion(BJYRequestToken, nil);
//    
//    // [self requestTokenWithKey:key completion:completion];
//}

#pragma mark - FlutterPlatformView

- (UIView *)view{
    
    return self.playerFatherView;
}


- (UIView *)playerFatherView
{
    if (!_playerFatherView) {
        _playerFatherView = UIView.new;
        _playerFatherView.backgroundColor = UIColor.blackColor;
    }
    
    return _playerFatherView;
}

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments
                                       eventSink:(FlutterEventSink)events{
    [_eventSink setDelegate:events];

    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments{
    [_eventSink setDelegate:nil];
    return nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSDictionary *args = call.arguments;
    
    if ([@"init" isEqualToString:call.method]) {
        // 初始化方法
        result(nil);
    }else if ([@"isReleased" isEqualToString:call.method]) {
        BOOL isReleased  =   [self.playerUIVC IsReleased];
        // 是否已释放
        result([NSNumber numberWithBool:isReleased]);
    }else if ([@"bindPlayerView" isEqualToString:call.method]) {
        // 绑定播放器视图
        result(nil);
    }else if ([@"play" isEqualToString:call.method]) {
        // 播放
        [self.playerUIVC ExecutePlay];
        result(nil);
    }else if ([@"pause" isEqualToString:call.method]) {
        // 播放
        [self.playerUIVC ExecutePause];

        result(nil);
    }else if ([@"stop" isEqualToString:call.method]) {
        // 停止
        [self.playerUIVC ExecuteStop];

        result(nil);
    }else if ([@"released" isEqualToString:call.method]) {
        // 释放资源
        [self.playerUIVC ExecuteReleased];

        
        result(nil);
    }else if ([@"rePlay" isEqualToString:call.method]) {
        // 重播
        [self.playerUIVC ExecuteRePlay];

        result(nil);
    }else if ([@"seek" isEqualToString:call.method]) {
        // 跳转到
        NSNumber *time = args[@"time"];
        [self.playerUIVC ExecuteSeekWitTime:time];
        result(nil);
    }else if ([@"isPlaying" isEqualToString:call.method]) {
        // 是否正在播放
        BOOL isPlaying  =   [self.playerUIVC isPlaying];
        // 是否已释放
        result([NSNumber numberWithBool:isPlaying]);
    }else if ([@"hideBackIcon" isEqualToString:call.method]) {
        // 隐藏返回按钮
        [self.playerUIVC ExecuteHideBackIcon:true];
        result(nil);
    }else if ([@"tryOpenFloatViewPlay" isEqualToString:call.method]) {
        // 打开悬浮窗
        FloatPlayerView *floatPlayeView = [FloatPlayerView shareFloatPlayerView];
        [floatPlayeView showInWindowFromVideoPlayer:self.playerUIVC];
        result(nil);
    }else if ([@"setupOnlineVideoWithId" isEqualToString:call.method]) {
        // 根据videoId token 播放视频
        NSString *videoId = args[@"videoId"];
        NSString *token = args[@"token"];
        [self.playerUIVC playWithVid:videoId token:token];
        result(nil);
    }else {
        result(FlutterMethodNotImplemented);
    }
}

//onToggleScreen
- (void)onToggleScreen:(BOOL) isFullScreen {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"BjyPlayerListener",
        @"method": @"onToggleScreen",
        @"data": @{
           @"isFullScreen": [NSNumber numberWithBool:isFullScreen],
        },
    };
    [_eventSink success:eventData];
}
//onBack

///// 播放状态发生变化
//- (void)onStatusChange:(NSString) playState {
//    NSDictionary<NSString *, id> *eventData = @{
//        @"listener": @"BjyPlayerListener",
//        @"method": @"onStatusChange",
//        @"data": @{
//                @"playerStatus": [NSString playState],
//        },
//    };
//    self.eventSink(eventData);
//}
//
//
///// 播放进度发生变化
//- (void)onPlayingTimeChange:(int) current duration:(int) duration {
//    NSDictionary<NSString *, id> *eventData = @{
//        @"listener": @"BjyPlayerListener",
//        @"method": @"onPlayingTimeChange",
//        @"data": @{
//                @"cur": [NSNumber numberWithInt:current],
//                @"dur": [NSNumber numberWithInt:duration],
//        },
//    };
//    self.eventSink(eventData);
//}


@end
