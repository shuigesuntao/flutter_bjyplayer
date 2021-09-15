//
//  WXVideoPlayerView+UIControl.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/28.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXVideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoPlayerView (UIControl)
- (void)setupSubviews;

- (void)updateConstriantsWithLayoutType:(BJYPlayerViewLayoutType)layoutType;
- (void)updatePlayerViewConstraintWithVideoRatio:(CGFloat)ratio;
- (void)updatePlayProgress;
- (void)updateWithPlayState:(BJVPlayerStatus)state;
- (void)showMediaSettingView;




@end

NS_ASSUME_NONNULL_END
