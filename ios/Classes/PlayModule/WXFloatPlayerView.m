//
//  WXFloatPlayerView.m
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXFloatPlayerView.h"
#import "BJPUTheme.h"
#import "WXPlayOptionsManager.h"
#import "WXVideoPlayerView+PublicHeader.h"
#import "WXFloatFullScreenViewController.h"
#import "Helper.h"
#import "SGParameter.h"
#import "UIViewController+ModalPresentation.h"

static CGFloat const kButtomBarViewHeight = 89.f;

@interface WXFloatPlayerView()<UIGestureRecognizerDelegate,WXVideoPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *fullButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, assign) CGFloat playerViewWidth;
@property (nonatomic, assign) CGFloat playerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
//拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
@property (nonatomic, strong) UITapGestureRecognizer * singleTap;
//捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;
//记录失去焦点时屏幕状态
@property (nonatomic, assign) UIDeviceOrientation lastDeviceOrientation;

@property (nonatomic, strong) NSString *currentTime;

@property (nonatomic, assign) NSInteger playCumulativeTime;
@property (nonatomic, assign) long playDuration;
@property (nonatomic, strong) WXVideoPlayerView *videoPlayerView;

@end

@implementation WXFloatPlayerView


static WXFloatPlayerView *floatPlayerView = nil;
static dispatch_once_t onceToken;

static CGPoint lastCenter;

-(void)dealloc{
    
    self.videoPlayerView.playerDelegate = nil;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _playerViewWidth = [UIScreen mainScreen].bounds.size.width * 0.5;
    _playerViewHeight = _playerViewWidth * 9.f/16.f;
    [self addPlayerViewGestureRecognizerEvents];
    
}

+ (instancetype)shareFloatPlayerView {
    
    dispatch_once(&onceToken, ^{
        floatPlayerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    });
    return floatPlayerView;
}


- (void)showInWindowWithPlayWithVid:(NSString *)vid token:(NSString *)token {
    
    if (self.videoPlayerView) {
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WXVideoPlayerView class]]) {
                    WXVideoPlayerView *playView = (WXVideoPlayerView *)obj;
                    [playView  destroyVideoPlayerView];
                    playView.playerDelegate = nil;
                    playView = nil;
                }
            }];
        }
        self.videoPlayerView.playerManager = nil;
        [self.videoPlayerView playWithVid:vid token:token];
    }else{
        WXVideoPlayerView *playerView = [[WXVideoPlayerView alloc] initWithFrame:CGRectZero videoOptions:[WXPlayOptionsManager getVideoOptions] surperView:self playerViewScreenType:(BJYPlayerViewScreenSimpleType)];
        [playerView playWithVid:vid token:token];
        [self showInWindowFromVideoPlayer:playerView];
    }
    
}

- (void)showInWindowWithDownloadItem:(BJVDownloadItem *)downloadItem {

    if (self.videoPlayerView) {
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
            [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WXVideoPlayerView class]]) {
                    WXVideoPlayerView *playView = (WXVideoPlayerView *)obj;
                    [playView  destroyVideoPlayerView];
                    playView.playerDelegate = nil;
                    playView = nil;
                }
            }];
        }
        self.videoPlayerView.playerManager = nil;
        [self.videoPlayerView playWithDownloadItem:downloadItem];
    }else{
        WXVideoPlayerView *playerView = [[WXVideoPlayerView alloc] initWithFrame:CGRectZero videoOptions:[WXPlayOptionsManager getVideoOptions] surperView:self playerViewScreenType:(BJYPlayerViewScreenSimpleType)];
        [playerView playWithDownloadItem:downloadItem];
        [self showInWindowFromVideoPlayer:playerView];
    }
    
    
}

- (void)addPlayerViewGestureRecognizerEvents{
  
    //拖拽手势
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    self.panGesture = panGesture;
    
    
    
    /*
     //单击手势
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick)];
     singleTap.delegate = self;
     singleTap.numberOfTapsRequired = 1; //单击
     [self addGestureRecognizer:singleTap];
     self.singleTap = singleTap;
     //捏合手势
     UIPinchGestureRecognizer* pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
     [self addGestureRecognizer:pinGesture];
     pinGesture.enabled = NO;
     self.pinchGesture = pinGesture;
    */
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)showInWindowFromVideoPlayer:(WXVideoPlayerView *)videoPlayer{
  
    self.videoPlayerView = videoPlayer;
    self.videoPlayerView.playerDelegate = self;
    if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WXVideoPlayerView class]]) {
                WXVideoPlayerView *playView = (WXVideoPlayerView *)obj;
                [playView  destroyVideoPlayerView];
                playView.playerDelegate = nil;
                playView = nil;
            }
        }];
        [self removeFromSuperview];
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat y = screenHeight - _playerViewHeight - kButtomBarViewHeight;
    self.frame = CGRectMake(screenWidth - _playerViewWidth, screenHeight, _playerViewWidth, _playerViewHeight);
    [self addSubview:videoPlayer];
    [videoPlayer bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    videoPlayer.isForbidRotate = YES;
    videoPlayer.playType = BJYPlayerViewScreenSimpleType;
    [videoPlayer continuePlay];
    [self bringSubviewToFront:self.closeButton];
   // [self bringSubviewToFront:self.durationLabel];
    [self bringSubviewToFront:self.progressView];
    [self bringSubviewToFront:self.playButton];
    [self bringSubviewToFront:self.fullButton];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = y;
        self.frame = frame;
        lastCenter = self.center;
    }];
    self.hidden = NO;
}

#pragma mark - 将失去焦点通知

- (void)willResignActive{
    
    self.lastDeviceOrientation = [UIDevice currentDevice].orientation;
    
}
#pragma mark - 获取焦点通知

- (void)becomeActive{

}

#pragma mark- UIPinchGestureRecognizer

- (void)doubleClick{
    
}

- (void)singleClick{
    if (self.videoPlayerView.isFullscreen || self.videoPlayerView.playType == BJYPlayerViewScreenFullScreenType) {
        return;
    }
    [self configFloatSubViewHidden:YES];
    [self configGestureRecognizerEnable:NO];
    self.videoPlayerView.layoutType = BJYPlayerViewLayoutType_FullHorizon;
    self.videoPlayerView.isFullscreen = YES;
    [self.videoPlayerView setPlayType:BJYPlayerViewScreenFullScreenType];
    __weak typeof(self) weakSelf = self;
    if (@available(ios 13.0,*)) {
        WXFloatFullScreenViewController *fullScreenController = [[WXFloatFullScreenViewController alloc] initWithVideoPlayerView:self.videoPlayerView];
        fullScreenController.videoBackBlock = ^(WXVideoPlayerView *playerView) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (![[UIApplication sharedApplication].keyWindow.subviews containsObject:strongSelf]) {
                [[UIApplication sharedApplication].keyWindow addSubview:strongSelf];
            }
            strongSelf.videoPlayerView = playerView;
            if (![strongSelf.subviews containsObject:playerView]) {
                [strongSelf addSubview:strongSelf.videoPlayerView];
                [strongSelf sendSubviewToBack:strongSelf.videoPlayerView];
                [strongSelf.videoPlayerView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
                    make.edges.equalTo(strongSelf);
                }];
            }
            [strongSelf backAction];
        };
        [self removeFromSuperview];
        [[Helper currentViewController] presentModalViewController:fullScreenController animated:YES completion:nil];
        
    }else{
        self.videoPlayerView.cancelCallback = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf backAction];
        };
        self.bounds = [self getFullScreenBounds];
        self.center = [UIApplication sharedApplication].keyWindow.center;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            UIView *lightView = [self.videoPlayerView.sliderView valueForKey:@"lightView"];
            lightView.transform = CGAffineTransformIdentity;
            lightView.transform = CGAffineTransformMakeRotation(M_PI_2);
            //volumeView
            UIView *volumeView = [self.videoPlayerView.sliderView valueForKey:@"volumeView"];
            volumeView.transform = CGAffineTransformMakeRotation(M_PI_2);
            
        }];
    }
    
}


- (void)backAction{
    self.videoPlayerView.layoutType = BJYPlayerViewLayoutType_Vertical;
    self.videoPlayerView.playType = BJYPlayerViewScreenSimpleType;
    self.videoPlayerView.isFullscreen = NO;
    [self configGestureRecognizerEnable:YES];
    [self configFloatSubViewHidden:NO];
    if (@available(ios 13.0,*)) {
        
    }else{
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    }
    [UIView animateWithDuration:0.05 animations:^{
        self.transform = CGAffineTransformIdentity;
        UIView *lightView = [self.videoPlayerView.sliderView valueForKey:@"lightView"];
        lightView.transform = CGAffineTransformIdentity;
        //volumeView
        UIView *volumeView = [self.videoPlayerView.sliderView valueForKey:@"volumeView"];
        volumeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.bounds = CGRectMake(0, 0,self.playerViewWidth, self.playerViewHeight);
        self.center = lastCenter;
    }];
    
}

- (void)configGestureRecognizerEnable:(BOOL)enable{
    self.singleTap.enabled = enable;
    self.panGesture.enabled = enable;
}

- (void)configFloatSubViewHidden:(BOOL)isHidden{
    self.closeButton.hidden = isHidden;
    self.durationLabel.hidden = YES;
    self.playButton.hidden = isHidden;
    self.fullButton.hidden = isHidden;
    self.progressView.hidden = isHidden;
}


- (CGRect)getFullScreenBounds{
    
    CGFloat height =  [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (height > width) {
        return  CGRectMake(0, 0, height, width);
    }else{
        return  CGRectMake(0, 0, width, height);
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed)
    {
        self.panGesture.enabled = YES;
        return;
    }
    self.panGesture.enabled = NO;
    CGSize newSize = CGSizeMake(self.frame.size.width * gesture.scale, self.frame.size.height * gesture.scale);
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (newSize.width > size.width)
    {
        gesture.enabled = NO;
        self.panGesture.enabled = NO;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.frame = CGRectMake(0, self.frame.origin.y, size.width, self.playerViewWidth);
        }
                         completion:^(BOOL finished)
         {
             gesture.enabled = YES;
             self.panGesture.enabled = YES;
             
         }];
    }
    else if (newSize.width < 150)
    {
        
    }
    else
    {
        CGRect frame = self.frame;
        CGSize size = frame.size;
        CGFloat scale = gesture.scale;
        self.frame = CGRectMake(frame.origin.x - (size.width * scale - size.width) / 2, frame.origin.y - (size.height * scale - size.height) / 2, size.width * scale, size.height * scale);
        
    }
    [gesture setScale:1];
}

#pragma mark- UIPanGestureRecognizer
- (void)handlePanGesture:(UIPanGestureRecognizer*)gesture
{
    if (gesture.numberOfTouches > 1)
    {
        return;
    }

    CGPoint point = [gesture locationInView:[UIApplication sharedApplication].keyWindow];//指点击屏幕实时的坐标点
    static CGPoint center;
    static CGPoint lastPoint;
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            lastPoint = point;
            center = self.center;
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint newCenter=CGPointMake(center.x + point.x - lastPoint.x, center.y + point.y - lastPoint.y);
            
            self.center =newCenter;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGSize size=[UIScreen mainScreen].bounds.size;
            lastCenter= self.center;
            
            if (lastCenter.x < self.frame.size.width * 0.5 && lastCenter.x > self.playerViewWidth * 0.1)
            {
                lastCenter.x =  self.frame.size.width * 0.5;
            }
            else if (lastCenter.x > size.width - self.frame.size.width * 0.5)
            {
                lastCenter.x = size.width - self.frame.size.width * 0.5 ;
            } else if (lastCenter.x < self.playerViewWidth * 0.1) {
                //浮动窗口向左划出屏幕40%移除浮动窗口
                lastCenter.x =  self.frame.size.width * 0.5;
            }
            
            if (lastCenter.y < self.frame.size.height * 0.5)
            {
                lastCenter.y =  self.frame.size.height * 0.5;
            }
            else if (lastCenter.y> size.height - self.frame.size.height * 0.5)
            {
                lastCenter.y = size.height - self.frame.size.height * 0.5;
            }
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                self.center=lastCenter;
            }
                             completion:^(BOOL finished)
             {
                 
             }];
        }
            break;
        default:
            break;
    }
    
}


#pragma mark- 关闭／播放的监听事件

- (IBAction)closeClick:(UIButton *)sender {
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = ScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        self.playCumulativeTime = self.videoPlayerView.playCumulativeTime;
        self.currentTime = [NSString stringWithFormat:@"%lld",(long long)self.videoPlayerView.playerManager.currentTime];
        if (![Helper isBlankString:self.chapterID] && ![Helper isBlankString:self.currentTime]) {
            [self getVideoPlayProgress];
        }
        [self.videoPlayerView destroyVideoPlayerView];
        self.videoPlayerView.playerDelegate = nil;
        self.videoPlayerView = nil;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
        if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]){
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self removeFromSuperview];
        }
    }];
    floatPlayerView = nil;
    onceToken = 0;
    
}

- (void)destroyFloatVideoPlayerView{
    self.playCumulativeTime = self.videoPlayerView.playCumulativeTime;
    self.currentTime = [NSString stringWithFormat:@"%lld",(long long)self.videoPlayerView.playerManager.currentTime];
    if (![Helper isBlankString:self.chapterID] && ![Helper isBlankString:self.currentTime]) {
        if (self.videoPlayerView && [self.currentTime integerValue] > 1) {
            [self getVideoPlayProgress];
        }
    }
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [self.videoPlayerView destroyVideoPlayerView];
    self.videoPlayerView.playerDelegate = nil;
    self.videoPlayerView = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self removeFromSuperview];
    floatPlayerView = nil;
    onceToken = 0;
}

#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer
{
    NSLog(@"%@", otherGestureRecognizer.view.class);
    if (gestureRecognizer == self.panGesture && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]])
    {
        return NO;
    }
    /*
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && otherGestureRecognizer == self.pinchGesture)
    {
        return NO;
    }
    if (gestureRecognizer == self.pinchGesture && otherGestureRecognizer == self.panGesture)
    {
        return NO;
    }
     */
    return YES;
}

#pragma mark - submit video progress

- (void)getVideoPlayProgress{
    [self submitStudyProgress:0];
}

- (void)submitStudyProgress:(long)progressTime{

    if (progressTime >= (long)self.playDuration + 10) {
        return;
    }
    if ([Helper isBlankString:self.currentTime]) {
        return;
    }
    CGFloat intervalTime = self.playCumulativeTime * 0.5;
    if (intervalTime < 2) {
        return;
    }
    SGParameter *para = [SGParameter new];
    para.body = @{@"time" : self.currentTime,
                  @"chapter_id" : _chapterID?:@"",
                  @"current_time":[NSString stringWithFormat:@"%.f",intervalTime]
                    };

    [self handleStatisticsStudyProgress];
}

- (void)handleStatisticsStudyProgress{
  
}
#pragma mark - WXVideoPlayerViewDelegate

- (void)getVideoPlayerWithPlayCurrentTime:(NSTimeInterval )currentTime duration:(NSTimeInterval )duration{
    BOOL durationInvalid = (ceil(duration) <= 0);
    if (!durationInvalid) {
        self.playDuration = (long)duration;
    }
    if (currentTime > 0) {
        self.currentTime = [NSString stringWithFormat:@"%lld",(long long)currentTime];
        if(self.videoPlayerView.playerManager.playStatus == BJVPlayerStatus_reachEnd){
            self.currentTime = [NSString stringWithFormat:@"%lld",(long long)duration];
        }
    }
    NSLog(@"getVideoPlayerWithPlayCurrentTime:%@+++++++++++++++++",self.currentTime);
    self.progressView.progress = durationInvalid ? 0.f : (currentTime / duration);
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    int hours = interval / 3600;
    int minums = ((long long)interval % 3600) / 60;
    int seconds = (long long)interval % 60;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minums, seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02d:%02d", minums, seconds];
    }
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval totalTimeInterval:(NSTimeInterval)total {
    int hours = interval / 3600;
    int minums = ((long long)interval % 3600) / 60;
    int seconds = (long long)interval % 60;
    int totalHours = total / 3600;
    
    if (totalHours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minums, seconds];
    }
    else {
        return [NSString stringWithFormat:@"%02d:%02d", minums, seconds];
    }
}

- (void)getVideoBJVPlayerStatus:(BJVPlayerStatus)status{
    //播放完成 失败 移除播放器
    if (status == BJVPlayerStatus_failed || status == BJVPlayerStatus_reachEnd) {
        if (self.videoPlayerView.isFullscreen) {
            return;
        }
        if (@available(ios 13.0,*)) {
            
        }else{
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }
        [self destroyFloatVideoPlayerView];
    }
}
- (IBAction)fullScreenAction:(id)sender {
    [self singleClick];
}
- (IBAction)playAction:(id)sender {
    if (self.videoPlayerView.playerManager.playStatus == BJVPlayerStatus_paused ||self.videoPlayerView.playerManager.playStatus == BJVPlayerStatus_stopped) {
        [self.videoPlayerView.playerManager play];
        [self getVideoPlayProgress];
        [self.playButton setImage:[UIImage imageNamed:@"float_pause"] forState:(UIControlStateNormal)];
        
    }else if (self.videoPlayerView.playerManager.playStatus == BJVPlayerStatus_playing){
        [self.videoPlayerView.playerManager pause];
        [self.playButton setImage:[UIImage imageNamed:@"float_play"] forState:(UIControlStateNormal)];
    }
}
@end
