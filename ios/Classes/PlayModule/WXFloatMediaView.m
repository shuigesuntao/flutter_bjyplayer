//
//  WXFloatMediaView.m
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/7/1.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXFloatMediaView.h"
#import <BJVideoPlayerUI.h>
#import "BJPUViewController+protected.h"

@interface WXFloatMediaView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat playerViewWidth;
@property (nonatomic, assign) CGFloat playerViewHeight;

@property (nonatomic, weak) UIButton *playButton;
@property (nonatomic, weak) UIButton *closeButton;
//拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer * panGesture;
//捏合手势
@property (nonatomic, strong) UIPinchGestureRecognizer * pinchGesture;

@end

@implementation WXFloatMediaView

static WXFloatMediaView *mediaView = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharetMediaView{
    dispatch_once(&onceToken, ^{
        mediaView = [[WXFloatMediaView alloc] init];
    });
    return mediaView;
}

- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupSubview];

        [self addPlayerViewGestureRecognizerEvents];
        [self layoutCustomSubviews];
    }
    return self;
}

- (void)layoutCustomSubviews {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    _playerViewWidth = 50;
    _playerViewHeight = 84;
    self.frame = CGRectMake(screenWidth - _playerViewWidth, screenHeight, _playerViewWidth, _playerViewHeight);
}

- (void)setupSubview {
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(0, 0, 49, 49);
    [playButton setImage:[UIImage imageNamed:@"course_voice_puase"] forState:UIControlStateNormal];
    [playButton setImage:[UIImage imageNamed:@"course_voice_play"] forState:UIControlStateSelected];
    [playButton addTarget:self action:@selector(clickToPlayPuase:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    self.playButton = playButton;
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, CGRectGetMaxY(self.playButton.frame), 50, 34);
    [closeButton setImage:[UIImage imageNamed:@"course_voice_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(clickToCloseVoice) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    self.closeButton = closeButton;
    
}

- (void)addPlayerViewGestureRecognizerEvents{
    
    
    //拖拽手势
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGesture];
    panGesture.delegate = self;
    self.panGesture = panGesture;
    /*
    //捏合手势
    UIPinchGestureRecognizer* pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinGesture];
    pinGesture.enabled = NO;
    self.pinchGesture = pinGesture;
    //单击手势
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleClick:)];
    singleTap.numberOfTapsRequired = 1; //单击
    [self addGestureRecognizer:singleTap];
     */
    
}


#pragma mark- UIPinchGestureRecognizer

- (void)doubleClick{
    
}

- (void)singleClick:(UITapGestureRecognizer *)singleTap{
    
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
            CGPoint lastCenter=self.center;
            
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


- (void)clickToPlayPuase:(UIButton *)sender {
    
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        [self.playerUIVC.playerManager pause];
    } else {
        [self.playerUIVC.playerManager play];
    }
}

- (void)clickToCloseVoice {
    /// 释放播放及其悬浮
    [self.playerUIVC.updateDurationTimer invalidate];
    self.playerUIVC.updateDurationTimer = nil;
    [self.playerUIVC.reachablityManager stopMonitoring];
    [self bjl_stopAllKeyValueObservingOfTarget:self];
    [self.playerUIVC.playerManager pause];
    [self.playerUIVC.playerManager destroy];
    [self.playerUIVC willMoveToParentViewController:nil];
    [self.playerUIVC  removeFromParentViewController];
    [self.playerUIVC.view  removeFromSuperview];
    self.playerUIVC = nil;
    [self removeViewAnimation];
}

- (void)showAnimation {
    
     bjl_weakify(self);
    [self bjl_kvo:BJLMakeProperty(self.playerUIVC.playerManager, playStatus) filter:^BOOL(NSNumber *  _Nullable value, NSNumber * _Nullable oldValue, BJLPropertyChange * _Nullable change) {
        return (oldValue == nil) || (value.integerValue != oldValue.integerValue);
    } observer:^BOOL(id  _Nullable value, id  _Nullable oldValue, BJLPropertyChange * _Nullable change) {
        bjl_strongify(self);
        BJVPlayerStatus status = self.playerUIVC.playerManager.playStatus;
        if (status == BJVPlayerStatus_failed || status == BJVPlayerStatus_reachEnd) {
            [self clickToCloseVoice];
        }
        
        return YES;
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.35 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = screenHeight - 49.f - 140;
        self.frame = frame;
    }];
}

- (void)removeViewAnimation {
    [self removeFromSuperview];
    mediaView = nil;
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


@end

@implementation BJYFloatMediaManager


/**
 显示播放器
 */
+ (void)bjy_showVoiceView{
    WXFloatMediaView *voiceV = [[UIApplication sharedApplication].keyWindow viewWithTag:BJY_voiceViewTag];
    if (voiceV) {
        [voiceV clickToCloseVoice];
        [voiceV removeViewAnimation];
    }
    voiceV = [WXFloatMediaView sharetMediaView];
    voiceV.tag = BJY_voiceViewTag;
    [voiceV showAnimation];
}

/**
 隐藏播放器
 */
+ (void)bjy_hiddenVoiceView{
    WXFloatMediaView *voiceV = [[UIApplication sharedApplication].keyWindow viewWithTag:BJY_voiceViewTag];
    if (voiceV) {
        [voiceV removeViewAnimation];
        [voiceV.playerUIVC.playerManager pause];
    }

}

/**
 移除播放器以及播放源
 */
+ (void)bjy_removeVoiceView{
    WXFloatMediaView *voiceV = [[UIApplication sharedApplication].keyWindow viewWithTag:BJY_voiceViewTag];
    if (voiceV) {
        [voiceV clickToCloseVoice];
        [voiceV removeViewAnimation];
    }
}


@end
