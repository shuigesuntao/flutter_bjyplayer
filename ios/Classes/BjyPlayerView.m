//
//  BjyPlayerView.m
//  Pods
//
//  Created by Sun on 2021/9/5.
//

#import "BjyPlayerView.h"
#import "BjyPlayerEventSink.h"
#import <BJVideoPlayerUI/BJVideoPlayerUI.h>

@interface BjyPlayerView ()

@property (nonatomic, strong) BJPUViewController *playerUIVC;
@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) FlutterEventChannel *eventChannel;
@property (nonatomic, strong) BjyPlayerEventSink *eventSink;

@end

@implementation BjyPlayerView


+ (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args registrar:(id<FlutterPluginRegistrar>)registrar{
    BjyPlayerView *playerView = [[BjyPlayerView alloc] initWithRegistrar:registrar viewIdentifier:viewId];
    return playerView;
}

- (instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar viewIdentifier:(int64_t)viewId{
    if (self = [self init]) {
        __weak typeof(self) weakSelf = self;
        // 初始化
        // 移除悬浮窗
        // 设置播放器控制样式
        // 设置监听
        _methodChannel = [FlutterMethodChannel methodChannelWithName:[@"plugin.bjyPlayer_" stringByAppendingString:[NSString stringWithFormat:@"%@", @(viewId)]] binaryMessenger:[registrar messenger]];
        [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            [weakSelf handleMethodCall:call result:result];
        }];
        _eventChannel = [FlutterEventChannel eventChannelWithName:[@"plugin.bjyPlayer_event_" stringByAppendingString:[NSString stringWithFormat:@"%@", @(viewId)]] binaryMessenger:[registrar messenger]];
        [_eventChannel setStreamHandler:self];
    }
    
    return self;
}

- (UIView*)view {
    return playerFatherView;
}

- (FlutterError*)onListenWithArguments:(id)arguments sink:(FlutterEventSink)eventSink {
    eventSink.setDelegate(sink);
    
    return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    eventSink.setDelegate(nil);
   
    return nil;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result{
    NSDictionary *args = call.arguments;
    
    if ([@"init" isEqualToString:call.method]) {
        // 初始化方法
        result(nil);
    }else if ([@"isReleased" isEqualToString:call.method]) {
        // 是否已释放
        result(nil);
    }else if ([@"bindPlayerView" isEqualToString:call.method]) {
        // 绑定播放器视图
        result(nil);
    }else if ([@"play" isEqualToString:call.method]) {
        // 播放
        result(nil);
    }else if ([@"pause" isEqualToString:call.method]) {
        // 播放
        result(nil);
    }else if ([@"stop" isEqualToString:call.method]) {
        // 停止
        result(nil);
    }else if ([@"released" isEqualToString:call.method]) {
        // 释放资源
        result(nil);
    }else if ([@"rePlay" isEqualToString:call.method]) {
        // 重播
        result(nil);
    }else if ([@"seek" isEqualToString:call.method]) {
        // 跳转到
        NSNumber *time = args[@"time"];
        result(nil);
    }else if ([@"isPlaying" isEqualToString:call.method]) {
        // 是否正在播放
        result(nil);
    }else if ([@"hideBackIcon" isEqualToString:call.method]) {
        // 隐藏返回按钮
        result(nil);
    }else if ([@"tryOpenFloatViewPlay" isEqualToString:call.method]) {
        // 打开悬浮窗
        result(nil);
    }else if ([@"setupOnlineVideoWithId" isEqualToString:call.method]) {
        // 根据videoId token 播放视频
        NSString *videoId = args[@"videoId"];
        NSString *token = args[@"token"];
        [self.playerUIVC playWithVid:videoId token:token]
        result(nil);
    }else {
        result(FlutterMethodNotImplemented);
    }
}

//onToggleScreen

//onBack

/// 播放状态发生变化
- (void)onStatusChange:(NSString) playState {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"BjyPlayerListener",
        @"method": @"onStatusChange",
        @"data": @{
                @"playerStatus": [NSString playState],
        },
    };
    self->_eventSink(eventData);
}


/// 播放进度发生变化
- (void)onPlayingTimeChange:(int) current duration:(int) duration {
    NSDictionary<NSString *, id> *eventData = @{
        @"listener": @"BjyPlayerListener",
        @"method": @"onPlayingTimeChange",
        @"data": @{
                @"cur": [NSNumber numberWithInt:current],
                @"dur": [NSNumber numberWithInt:duration],
        },
    };
    self->_eventSink(eventData);
}


