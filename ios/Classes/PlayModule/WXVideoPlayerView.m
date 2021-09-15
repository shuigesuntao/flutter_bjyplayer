//
//  BJYPlayerView.m
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019年 oushizishu. All rights reserved.
//
#import "WXVideoPlayerView+PublicHeader.h"
#import "BJPUProgressView.h"
#import "BJPUSliderView.h"

#import "BJPUTheme.h"
#import "WXVideoPlayerView.h"
#import "BJPUAppearance.h"

#import "WXVideoPlayerView+UIControl.h"
#import "WXVideoPlayerView+media.h"
#import "WXVideoPlayerView+observer.h"
#import "WXVideoPlayerView+reachability.h"
///录播课播放 1：继续播放下节 2：暂停 3：循环播放
NSString *ApprecordedResponseEvent = @"3";

UIKIT_STATIC_INLINE UIViewController *BJYCurrentViewController() {
    
    UIViewController *topViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        
        topViewController = ((UITabBarController *)topViewController).selectedViewController;
    }
    
    if ([topViewController presentedViewController]) {
        
        topViewController = [topViewController presentedViewController];
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
        
        return [(UINavigationController*)topViewController topViewController];
    }
    
    return topViewController;
}

@interface WXVideoPlayerView()<BJPUSliderProtocol>

@property (nonatomic, assign) CGFloat seekTargetTime;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) UIView *videoSurperView;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;
//记录方向
@property(nonatomic,assign)UIInterfaceOrientation interfaceOrientation;


@end

@implementation WXVideoPlayerView

- (CGRect )getFullScreenBounds{
    CGFloat height =  [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (height > width) {
        return  CGRectMake(0, 0, height, width);
    }else{
        return  CGRectMake(0, 0, width, height);
    }
}

- (void)dealloc {
    
    [self.updateDurationTimer invalidate];
    self.updateDurationTimer = nil;
    self.playerManager = nil;
    [self.reachablityManager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.needRecodTime = NO;
    self.playCumulativeTime = 0;
}

- (instancetype)initWithFrame:(CGRect)frame videoOptions:(BJPUVideoOptions *)videoOptions surperView:(UIView *)surperView playerViewScreenType:(BJYPlayerViewScreenType)playerViewScreenType {
    self = [super initWithFrame:frame];
    _originFrame = frame;
    if (self) {
        self.manualRotation = NO;
        self.isLockscreen = NO;
        self.isForbidRotate = NO;
        self.videoOptions = videoOptions;
        self.videoSurperView = surperView;
        [self setupVideoPlayer];
        self.playType = playerViewScreenType;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupVideoPlayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _originFrame = frame;
    if (self) {
        [self setupVideoPlayer];
    }
    return self;
}

- (void)setupVideoPlayer{
    self.backgroundColor = [UIColor bjl_colorWithHexString:@"#000000" alpha:0.95];
    [self listeningRotating];
    [self addDoubleGestureRecognizer];
    // 子视图
    [self setupSubviews];
    // 监听
    [self setupObservers];
    // callback
    [self setMediaCallbacks];
    // 网络检查
    [self setupReachabilityManager];
    
}

- (void)addDoubleGestureRecognizer{

    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired =2;
    doubleTapGesture.numberOfTouchesRequired =1;
    [self addGestureRecognizer:doubleTapGesture];
    self.doubleTapGesture = doubleTapGesture;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    BJYPlayerViewLayoutType layoutType = self.layoutType;
    [self updateConstriantsWithLayoutType:layoutType];
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview {
    // 更新布局
    [super willMoveToSuperview:newSuperview];
}

- (void)destroyVideoPlayerView {
    [self removeGestureRecognizer:self.doubleTapGesture];
    [self.updateDurationTimer invalidate];
    self.updateDurationTimer = nil;
    [self.reachablityManager stopMonitoring];
    [self bjl_stopAllKeyValueObserving];
    [self.playerManager pause];
    [self.playerManager destroy];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    self.needRecodTime = NO;
}
- (void)continuePlay{
    
    self.needRecodTime = YES;
    if (self.playerManager.playStatus == BJVPlayerStatus_paused ||self.playerManager.playStatus == BJVPlayerStatus_stopped || self.playerManager.playStatus == BJVPlayerStatus_loading) {
        [self.playerManager play];
    }
    
}


- (void)resetVideoPlayerView{
    [self.updateDurationTimer invalidate];
    self.updateDurationTimer = nil;
    self.needRecodTime = NO;
    [self.playerManager reset];
}

- (void)removeAndPauseVideoPlayerView{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [self removeFromSuperview];
    self.needRecodTime = NO;
    [self.playerManager pause];
}

#pragma mark - setters & getters

- (void)setPlayType:(BJYPlayerViewScreenType)playType{
    _playType = playType;
    if (playType == BJYPlayerViewScreenSimpleType) {
        self.mediaControlView.hidden = YES;
        self.topBarView.hidden = YES;
        self.sliderView.hidden = YES;
        self.mediaSettingView.hidden = YES;
        self.reloadView.hidden = YES;
        self.manualRotation = NO;
    }else{
        self.mediaControlView.hidden = NO;
        self.topBarView.hidden = NO;
        self.sliderView.hidden = NO;
        self.mediaSettingView.hidden = NO;
        self.reloadView.hidden = NO;
        [self clearOverlayViews];
        if (playType == BJYPlayerViewScreenNormalType) {
            self.topBarView.hidden = YES;
        }else{
            self.topBarView.hidden = NO;
        }

    }
}
- (BJVPlayerManager *)playerManager {
    if (!_playerManager) {
        _playerManager = ({
            BJVPlayerManager *manager = [[BJVPlayerManager alloc] initWithPlayerType:self.videoOptions.playerType];
            BJPUVideoOptions *options = self.videoOptions;
            manager.backgroundAudioEnabled = options.backgroundAudioEnabled;
            manager.preferredDefinitionList = options.preferredDefinitionList;
            manager.playTimeRecordEnabled = options.playTimeRecordEnabled;
            manager.initialPlayTime = options.initialPlayTime;
            manager.userName = options.userName;
            manager.userNumber = options.userNumber;
            manager;
        });
    }
    return _playerManager;
}

- (BJPUMediaControlView *)mediaControlView {
    if (!_mediaControlView) {
        _mediaControlView = ({
            BJPUMediaControlView *view = [[BJPUMediaControlView alloc] init];
            [view setSlideEnable:self.videoOptions.sliderDragEnabled];
            view;
        });
    }
    return _mediaControlView;
}

- (BJPUMediaSettingView *)mediaSettingView {
    if (!_mediaSettingView) {
        _mediaSettingView = [[BJPUMediaSettingView alloc] init];
        _mediaSettingView.hidden = YES;
    }
    return _mediaSettingView;
}

- (BJPUSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = ({
            BJPUSliderView *sliderView = [[BJPUSliderView alloc] init];
            sliderView.delegate = self;
            sliderView.slideEnabled = self.videoOptions.sliderDragEnabled;
            sliderView;
        });
    }
    return _sliderView;
}

- (UIImageView *)audioOnlyImageView {
    if (!_audioOnlyImageView) {
        _audioOnlyImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = [UIImage bjpu_imageNamed:@"ic_audio_only"];
            imageView;
        });
    }
    return _audioOnlyImageView;
}

- (UIView *)topBarView {
    if (!_topBarView) {
        _topBarView = ({
            UIView *view = [[UIView alloc] init];
            view.userInteractionEnabled = YES;
            view.backgroundColor = [[BJPUTheme brandColor] colorWithAlphaComponent:0.4];
            view;
        });
    }
    return _topBarView;
}

- (UIButton *)lockButton {
    if (!_lockButton) {
        _lockButton = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage bjpu_imageNamed:@"ic_lock"] forState:UIControlStateNormal];
            [button setImage:[UIImage bjpu_imageNamed:@"ic_unlock"] forState:UIControlStateSelected];
            button;
        });
    }
    return _lockButton;
}

- (BJPUReloadView *)reloadView {
    if (!_reloadView) {
        _reloadView = ({
            BJPUReloadView *view = [[BJPUReloadView alloc] init];
            view.hidden = YES;
            view;
        });
    }
    return _reloadView;
}

- (NSArray *)rateList {
    if (!_rateList) {
        // iOS 10以下系统在 0.7、1.2 倍速时会出现音视频不同步，换成 0.8、1.25
        if (@available(iOS 10.0, *)) {
            _rateList = @[@0.7, @1.0, @1.2, @1.5, @2.0];
        }
        else {
            _rateList = @[@0.8, @1.0, @1.25, @1.5, @2.0];
        }
    }
    return _rateList;
}

#pragma mark - public interface

- (void)playWithVid:(NSString *)vid token:(NSString *)token {
    self.isLocalVideo = NO;
    self.videoID = vid;
    self.token = token;
    self.downloadItem = nil;
    self.needRecodTime = YES;
    self.playCumulativeTime = 0;
    [self clearOverlayViews];
    [self.playerManager setupOnlineVideoWithID:vid
                                         token:token
                                     encrypted:self.videoOptions.encryptEnabled
                                     accessKey:nil];
    if (self.videoOptions.autoplay) {
        [self.playerManager play];
    }
}

- (void)playWithDownloadItem:(BJVDownloadItem *)downloadItem {
    self.isLocalVideo = YES;
    self.downloadItem = downloadItem;
    self.videoID = nil;
    self.token = nil;
    self.needRecodTime = YES;
    self.playCumulativeTime = 0;
    // 清理 overlay
    [self clearOverlayViews];
    
    // 初始化播放器
    [self.playerManager setupLocalVideoWithDownloadItem:downloadItem];
    if (self.videoOptions.autoplay) {
        [self.playerManager play];
    }
}

- (void)configLayoutType:(BJYPlayerViewLayoutType)layoutType {
    BOOL shouldupdate = (_layoutType != layoutType);
    _layoutType = layoutType;
    if (layoutType == BJYPlayerViewLayoutType_FullHorizon&& !self.isFullscreen) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
    }
    else if (layoutType == BJYPlayerViewLayoutType_Vertical && self.isFullscreen) {
        self.topBarView.hidden = YES;
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    }
    else if (shouldupdate) {
        [self updateConstriantsWithLayoutType:_layoutType];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gestureRecognizer{
    if (self.playType == BJYPlayerViewScreenSimpleType) {
        return;
    }
    if (self.playerManager.playStatus == BJVPlayerStatus_paused ||self.playerManager.playStatus == BJVPlayerStatus_stopped) {
        [self.playerManager play];
        [self.mediaControlView updateWithPlayState:YES];
    }else if (self.playerManager.playStatus == BJVPlayerStatus_playing){
        [self.playerManager pause];
        [self.mediaControlView updateWithPlayState:NO];
    }
}

#pragma mark - BJPUSliderProtocol

- (CGFloat)originValueForTouchSlideView:(BJPUSliderView *)touchSlideView {
    NSTimeInterval currentTime = self.playerManager.currentTime;
    return currentTime;
}

- (CGFloat)durationValueForTouchSlideView:(BJPUSliderView *)touchSlideView {
    return self.playerManager.duration;
}

- (void)touchSlideView:(BJPUSliderView *)touchSlideView finishHorizonalSlide:(CGFloat)value {
    // 控制频率，延时执行
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(videoSeekAction) object:nil];
    self.seekTargetTime = value;
    [self performSelector:@selector(videoSeekAction) withObject:nil afterDelay:0.8];
}

#pragma mark - action

- (void)videoSeekAction {
    [self seekToTime:self.seekTargetTime];
}

- (void)clearOverlayViews {
    self.reloadView.hidden = YES;
    self.mediaSettingView.hidden = YES;
}

#pragma mark - 监听设备旋转方向
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)handleDeviceOrientationChange
{
    if (self.playType == BJYPlayerViewScreenSimpleType) {
        self.manualRotation = NO;
    }
    if (self.isForbidRotate) {
        if (!self.manualRotation) {
            return;
        }
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    CGPoint center = [UIApplication sharedApplication].keyWindow.center;
    switch (interfaceOrientation) {
            
        case UIInterfaceOrientationPortraitUpsideDown: {
            /*
            _layoutType = BJYPlayerViewLayoutType_Vertical;
            self.isFullscreen = NO;
            self.transform = CGAffineTransformIdentity;
            self.frame = self.originFrame;
            UIView *lightView = [self.sliderView valueForKey:@"lightView"];
            lightView.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
            */
        } break;
        case UIInterfaceOrientationPortrait: {
            if (@available(ios 13.0,*)) {
                self.interfaceOrientation = interfaceOrientation;
            }else{
                [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
            }
            _layoutType = BJYPlayerViewLayoutType_Vertical;
            self.isFullscreen = NO;
            self.topBarView.hidden = YES;
            self.transform = CGAffineTransformIdentity;
            self.frame = self.originFrame;
            UIView *lightView = [self.sliderView valueForKey:@"lightView"];
            lightView.transform = CGAffineTransformIdentity;
            [self layoutIfNeeded];
            
        } break;
        case UIInterfaceOrientationLandscapeLeft: {
            if (@available(ios 13.0,*)) {
                self.interfaceOrientation=interfaceOrientation;
            }else{
                [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
            }
            _layoutType = BJYPlayerViewLayoutType_FullHorizon;
            self.isFullscreen = YES;
            self.bounds = [self getFullScreenBounds];

            self.center = center;
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformIdentity;
                self.transform = [self getCurrentDeviceOrientation];
                UIView *lightView = [self.sliderView valueForKey:@"lightView"];
                lightView.transform = CGAffineTransformIdentity;
                lightView.transform = [self getCurrentDeviceOrientation];
                [self layoutIfNeeded];
            }];
            
        } break;
        case UIInterfaceOrientationLandscapeRight: {
            if (@available(ios 13.0,*)) {
                self.interfaceOrientation=interfaceOrientation;
            }else{
                [[UIApplication sharedApplication] setStatusBarOrientation:interfaceOrientation animated:NO];
            }
            _layoutType = BJYPlayerViewLayoutType_FullHorizon;
            self.isFullscreen = YES;
            self.bounds = [self getFullScreenBounds];
            self.center = center;
            
            [UIView animateWithDuration:0.25 animations:^{
                self.transform = CGAffineTransformIdentity;
                self.transform = [self getCurrentDeviceOrientation];
                UIView *lightView = [self.sliderView valueForKey:@"lightView"];
                lightView.transform = CGAffineTransformIdentity;
                lightView.transform = [self getCurrentDeviceOrientation];
                [self layoutIfNeeded];
            }];
        } break;
            
        default:
            break;
    }
    
    if (self.screenDeviceOrientationDidChange) {
        self.screenDeviceOrientationDidChange(self.isFullscreen,interfaceOrientation);
    }
}

//获取当前的旋转状态
-(CGAffineTransform)getCurrentDeviceOrientation{
    UIViewController *currentVC =  BJYCurrentViewController();
    if (![currentVC shouldAutorotate]) {
        //状态条的方向已经设置过,所以这个就是你想要旋转的方向
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (@available(ios 13.0,*)) {
             orientation = self.interfaceOrientation;
        }
        //根据要进行旋转的方向来计算旋转的角度
        if (orientation ==UIInterfaceOrientationPortrait) {
            return CGAffineTransformIdentity;
        }else if (orientation ==UIInterfaceOrientationLandscapeLeft){
            return CGAffineTransformMakeRotation(-M_PI_2);
            
        }else if(orientation ==UIInterfaceOrientationLandscapeRight){
            return CGAffineTransformMakeRotation(M_PI_2);
        }
        return CGAffineTransformIdentity;
    }else {
        return CGAffineTransformIdentity;
    }
}

@end
