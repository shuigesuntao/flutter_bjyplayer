//
//  FloatPlayerView.m
//  flutter_bjyplayer
//
//  Created by 刘厚宽 on 2021/9/23.
//

#import "FloatPlayerView.h"
#import "FullScreenViewController.h"

static CGFloat const kButtomBarViewHeight = 89.f;


@interface FloatPlayerView ()<UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIButton *fullButton;
@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, assign) CGFloat playerViewWidth;
@property (nonatomic, assign) CGFloat playerViewHeight;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UILabel *durationLabel;
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
@property (nonatomic, strong) FullScreenViewController *fullVC;
@property (nonatomic, strong) BJPUViewController * playerUIVC;
@end

@implementation FloatPlayerView

static FloatPlayerView *floatPlayerView = nil;
static dispatch_once_t onceToken;

static CGPoint lastCenter;

-(void)dealloc{
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}
- (void)initUI{
    self.frame = CGRectMake(0, 0, 170, 120);
    self.backgroundColor = [UIColor whiteColor];
    _playerViewWidth = [UIScreen mainScreen].bounds.size.width * 0.5;
    _playerViewHeight = _playerViewWidth * 9.f/16.f;
    
    _closeButton = [UIButton new];
    [_closeButton setImage:[UIImage imageNamed:@"ic_back"] forState:normal];
    [_closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeButton];
    [_closeButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
            make.left.top.equalTo(self);
            make.width.height.equalTo(@28);
    }];
    _progressView = [UIProgressView new];
    _progressView.progressTintColor = [UIColor colorWithRed:252/255.0 green:86/255.0 blue:35/255.0 alpha:1];
    [self addSubview:_progressView];
    [_progressView bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@2);
    }];
    _fullButton = [UIButton new];
    [_fullButton setImage:[UIImage imageNamed:@"ic_scale"] forState:normal];
    [_fullButton addTarget:self action:@selector(fullScreenAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_fullButton];
    
    [_fullButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.bottom.equalTo(_progressView.bjl_top).offset(-10);
        make.centerX.equalTo(self.bjl_centerX).offset(12.5);
        make.width.height.equalTo(@15);
    }];
    _playButton = [UIButton new];
    [_playButton setImage:[UIImage imageNamed:@"ic_pause"] forState:normal];
    [_playButton setImage:[UIImage imageNamed:@"ic_play"] forState:normal];
    [_playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
    [_playButton bjl_makeConstraints:^(BJLConstraintMaker * _Nonnull make) {
        make.bottom.equalTo(_progressView.bjl_top).offset(-10);
        make.centerX.equalTo(self.bjl_centerX).offset(-12.5);
        make.width.height.equalTo(@15);
    }];
    
    [self addPlayerViewGestureRecognizerEvents];
}

+ (instancetype)shareFloatPlayerView {
    
    dispatch_once(&onceToken, ^{
        floatPlayerView =  [FloatPlayerView new];
    });
    return floatPlayerView;
}


- (void)showInWindowWithPlayWithVid:(NSString *)vid token:(NSString *)token {
    
    if (self.playerUIVC == nil) {
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

            
        }];
    }
    [self.playerUIVC playWithVid:vid token:token];
    [self showInWindowFromVideoPlayer:self.playerUIVC];
    
}

//- (void)showInWindowWithDownloadItem:(BJVDownloadItem *)downloadItem {
//
//
//
//}

- (void)addPlayerViewGestureRecognizerEvents{
    //拖拽手势
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    self.panGesture = panGesture;
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)showInWindowFromVideoPlayer:(BJPUViewController  *)playerVC{
    if ([[UIApplication sharedApplication].keyWindow.subviews containsObject:self]) {
        [self removeFromSuperview];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat y = screenHeight - _playerViewHeight - kButtomBarViewHeight;
    self.frame = CGRectMake(screenWidth - _playerViewWidth, screenHeight, _playerViewWidth, _playerViewHeight);
    [self addSubview:playerVC.view];
    playerVC.view.frame = self.frame;
    [playerVC viewDidLoad];
    [playerVC viewWillAppear:true];
    [playerVC viewDidAppear:true];
    [playerVC ExecutePlay];

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
    
}


- (void)backAction{
    
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

- (void)closeClick {
    
}

- (void)destroyFloatVideoPlayerView{
    
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



- (void)fullScreenAction {
    [self singleClick];
}
- (void)playAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    
    
}
@end
