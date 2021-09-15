//
//  WXVideoPlayerView+media.h
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXVideoPlayerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WXVideoPlayerView (media)

- (void)setMediaCallbacks;

- (void)seekToTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
