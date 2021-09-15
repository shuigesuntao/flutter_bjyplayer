//
//  WXVideoPlayerView+UIControl.m
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXVideoPlayerView+PublicHeader.h"
#import "BJPUTheme.h"
#import "WXVideoPlayerView+UIControl.h"
#import "UIButton+WXScaleAction.h"

@implementation WXVideoPlayerView (UIControl)
- (void)setupSubviews {
    // playerView
    UIView *playerView = self.playerManager.playerView;
    [self addSubview:playerView];
    [playerView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // audioOnlyImageView
    [self addSubview:self.audioOnlyImageView];
    [self.audioOnlyImageView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(playerView);
    }];
    
    // mediaControlView
    [self addSubview:self.mediaControlView];
    [self.mediaControlView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        if (@available(ios 13.0,*)) {
            if (self.isFullscreen) {
                make.left.equalTo(self).with.offset(STATUS_BAR_HEIGHT * 0.7);
                make.bottom.right.equalTo(self.bjl_safeAreaLayoutGuide ?: self);
                make.height.equalTo(@44.0).priorityHigh();
            }else{
                make.left.bottom.right.equalTo(self.bjl_safeAreaLayoutGuide ?: self);
                make.height.equalTo(@44.0).priorityHigh();
            }
        }else{
            make.left.bottom.right.equalTo(self.bjl_safeAreaLayoutGuide ?: self);
            make.height.equalTo(@44.0).priorityHigh();
        }
        
    }];
    
    // topBarView
    CGFloat topBarHeight = 44.0;
    [self addSubview:self.topBarView];
    
    [self updateTopBarViewConstraint];
//    [self.topBarView bjl_makeConstraints:^(BJLConstraintMaker *make) {
//        if (@available(ios 13.0,*)) {
//            if (self.isFullscreen) {
//                make.left.equalTo(self).with.offset(STATUS_BAR_HEIGHT * 0.7);
//                make.right.equalTo(self);
//                make.top.equalTo(self.mas_top).with.offset(STATUS_BAR_HEIGHT * 0.3);
//                make.height.equalTo(@(topBarHeight)).priorityHigh();
//            }else{
//                make.left.right.equalTo(self);
//                make.top.equalTo(self.mas_top).with.offset(STATUS_BAR_HEIGHT * 0.6);
//                make.height.equalTo(@(topBarHeight)).priorityHigh();
//            }
//        }else{
//            make.left.right.equalTo(self);
//            make.top.equalTo(self.mas_top).with.offset(STATUS_BAR_HEIGHT * 0.6);
//            make.height.equalTo(@(topBarHeight)).priorityHigh();
//        }
//
//    }];
    
    // cancelButton
    UIButton *cancelButton = ({
        UIButton *button = [[UIButton alloc] init];
        button.userInteractionEnabled = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [button setImage:[BJPUTheme backButtonImage] forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 15.0, 0.0, 0.0);
        [button removeTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.topBarView addSubview:cancelButton];
    [cancelButton dh_setEnlargeEdgeWithTop:0 right:20 bottom:20 left:0];
    [cancelButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self.topBarView.bjl_safeAreaLayoutGuide ?: self.topBarView);
        make.centerY.equalTo(self.topBarView);
        make.size.equal.sizeOffset(CGSizeMake(topBarHeight * 1.5, topBarHeight));
    }];
    
    // sliderView
    [self addSubview:self.sliderView];
    [self.sliderView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topBarView.bjl_bottom);
        make.bottom.equalTo(self.mediaControlView.bjl_top);
    }];
    
    // lockButton
    [self addSubview:self.lockButton];
    [self.lockButton bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self.bjl_safeAreaLayoutGuide ?: self).offset(35.0);
        make.centerY.equalTo(self);
    }];
    
    // mediaSettingView
    [self addSubview:self.mediaSettingView];
    [self.mediaSettingView bjl_updateConstraints:^(BJLConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.bjl_safeAreaLayoutGuide ?: self);
        make.width.equalTo(@(80.0));
    }];
    
    // reload view
    [self addSubview:self.reloadView];
    [self.reloadView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self setupControlActions];
    
}

- (void)updateTopBarViewConstraint {
    CGFloat topBarHeight = 44;
    [self.topBarView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        if (self.bjl_safeAreaLayoutGuide) {
            make.left.top.right.equalTo(self.bjl_safeAreaLayoutGuide); //ios11 以上直接用系统api
        }
        else {
            CGFloat statusBarHeight = MAX(20.0, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame));
            if (![Helper currentViewController].presentingViewController) {
                statusBarHeight = 0;  //这里仅仅present时才会适配状态栏，如果是内嵌view，则不会有顶部偏移
            }
            make.top.equalTo(self).offset(statusBarHeight); //ios11一下，没有刘海屏机型，所以适配只用+20pt
            make.left.right.equalTo(self);
        }
        make.height.equalTo(@(topBarHeight)).priorityHigh();
    }];
}

#pragma mark - actions

- (void)setupControlActions {
    // show & hide
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideInterfaceViews)];
    [self.sliderView addGestureRecognizer:tap];
    
    // lock
    [self.lockButton addTarget:self action:@selector(lockAction) forControlEvents:UIControlEventTouchUpInside];
    
    // cancel
    bjl_weakify(self);
    [self.reloadView setCancelCallback:^{
        bjl_strongify(self);
        [self cancelAction];
    }];
}

- (void)backAction {
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad && self.layoutType == BJYPlayerViewLayoutType_FullHorizon) {
        if (self.playType == BJYPlayerViewScreenFullScreenType) {
            [self cancelAction];
        }else{
            self.manualRotation = YES;
            [self configLayoutType:BJYPlayerViewLayoutType_Vertical];
        }
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.manualRotation = YES;
            [self configLayoutType:BJYPlayerViewLayoutType_Vertical];
        }
        [self cancelAction];
    }
}

- (void)cancelAction {
    if (self.cancelCallback) {
        self.cancelCallback();
    }
}

- (void)lockAction {
    BOOL lock = !self.lockButton.selected;
    self.lockButton.selected = lock;
    self.mediaControlView.hidden = lock;
    self.mediaSettingView.hidden = YES;
    self.topBarView.hidden = lock;
    self.sliderView.slideEnabled = !lock;
    [self.mediaControlView setSlideEnable:!lock];
    if (self.screenLockCallback) {
        self.screenLockCallback(lock);
    }
}

#pragma mark - show & hide

- (void)hideInterfaceViews {
    NSTimeInterval duration = 1.0;
    [self hideView:self.topBarView withDuration:duration];
    [self hideView:self.mediaControlView withDuration:duration];
    [self hideView:self.lockButton withDuration:duration];
}

- (void)hideInterfaceViewsAutomatically {
    if (!self.mediaControlView.slideCanceled) {
        // 进度条响应交互中，不执行隐藏
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInterfaceViewsAutomatically) object:nil];
        [self performSelector:@selector(hideInterfaceViewsAutomatically) withObject:nil afterDelay:5.0];
        return;
    }
    [self hideInterfaceViews];
}

- (void)showOrHideInterfaceViews {
    if (self.layoutType == BJYPlayerViewLayoutType_FullHorizon) {
        self.lockButton.hidden = !self.lockButton.hidden;
        [self hideView:self.mediaSettingView withDuration:0.5];
    }
    if (self.lockButton.selected) {
        return;
    }
    
    if (self.layoutType == BJYPlayerViewLayoutType_FullHorizon && !self.mediaSettingView.hidden) {
        self.mediaSettingView.hidden = YES;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInterfaceViewsAutomatically) object:nil];
    BOOL hidden = !self.mediaControlView.hidden;
    self.mediaControlView.hidden = hidden;
    
    if (self.layoutType == BJYPlayerViewLayoutType_FullHorizon) {
        self.topBarView.hidden = hidden;
    }
    if (!self.mediaControlView.hidden) {
        [self performSelector:@selector(hideInterfaceViewsAutomatically) withObject:nil afterDelay:5.0];
    }
}

- (void)hideView:(UIView *)view withDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        view.hidden = YES;
        view.alpha = 1.0;
    }];
}

#pragma mark - public

- (void)updateConstriantsWithLayoutType:(BJYPlayerViewLayoutType)layoutType {
    BOOL horizon = (layoutType == BJYPlayerViewLayoutType_FullHorizon);
    BOOL locked = self.lockButton.selected;
    if (locked && !horizon) {
        self.topBarView.hidden = NO;
        [self configLayoutType:BJYPlayerViewLayoutType_FullHorizon];
        return;
    }
    if (horizon || self.playType == BJYPlayerViewScreenFullScreenType) {
        self.topBarView.hidden = NO;
    }else{
        self.topBarView.hidden = YES;
    }
    [self configLayoutType:layoutType];
    [self updatePlayProgress];
    
    [self.mediaControlView updateConstraintsWithLayoutType:horizon];
    BOOL controlHidden = self.mediaControlView.hidden;
    // mediaSettingView: 1: 竖屏：直接隐藏；2.之前是隐藏状态，继续保持。
    self.mediaSettingView.hidden = !horizon || self.mediaSettingView.hidden;
    self.lockButton.hidden = !horizon || controlHidden;
    [self updateTopBarViewConstraint];
}

- (void)updatePlayerViewConstraintWithVideoRatio:(CGFloat)ratio {
    UIView *playerView = self.playerManager.playerView;
    [playerView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
        if (ratio > 0) {
            make.edges.equalTo(self).priorityHigh();
            make.width.equalTo(playerView.bjl_height).multipliedBy(ratio);
            make.center.equalTo(self);
            make.top.left.greaterThanOrEqualTo(self);
            make.bottom.right.lessThanOrEqualTo(self);
        }
        else {
            make.edges.equalTo(self);
        }
    }];
}

- (void)updatePlayerViewConstraintRatio{
    BJVDefinitionInfo *definitionInfo = self.playerManager.currDefinitionInfo;
    CGFloat width = definitionInfo.width;
    CGFloat height = definitionInfo.height;
    if (width > 0.0 && height > 0.0) {
        CGFloat videoRatio = width / height;
        // 更新播放视图宽高比
        [self updatePlayerViewConstraintWithVideoRatio:videoRatio];
    }
}
- (void)updatePlayProgress {
    NSTimeInterval curr = self.playerManager.currentTime;
    NSTimeInterval cache = self.playerManager.cachedDuration;
    NSTimeInterval total = self.playerManager.duration;
    
    if (self.needRecodTime) {
        BJVPlayerStatus status = self.playerManager.playStatus;
        if (status == BJVPlayerStatus_playing){
            self.playCumulativeTime++;
        }
    }
    NSLog(@"%ld++++++++++++++++playCumulativeTime+++++++++++",self.playCumulativeTime);
    if (self.playerDelegate&& [self.playerDelegate respondsToSelector:@selector(getVideoPlayerWithPlayCurrentTime:duration:)]) {
        [self.playerDelegate getVideoPlayerWithPlayCurrentTime:curr duration:total];
    }
    [self.mediaControlView updateProgressWithCurrentTime:curr
                                           cacheDuration:cache
                                           totalDuration:total];
}

- (void)updateWithPlayState:(BJVPlayerStatus)state {
    if (state == BJVPlayerStatus_paused ||
        state == BJVPlayerStatus_stopped ||
        state == BJVPlayerStatus_reachEnd ||
        state == BJVPlayerStatus_failed ||
        state == BJVPlayerStatus_ready) {
        [self.mediaControlView updateWithPlayState:NO];
    }
    else if (state == BJVPlayerStatus_playing) {
        [self.mediaControlView updateWithPlayState:YES];
    }
    
    [self updatePlayProgress];
}

- (void)showMediaSettingView {
    if (self.layoutType != BJYPlayerViewLayoutType_FullHorizon) {
        return;
    }
    [self hideInterfaceViews];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.mediaSettingView.hidden = NO;
    });
}


@end
