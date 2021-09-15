//
//  WXFloatFullScreenViewController.h
//  BJYWXOnlineSchool
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 JackMac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXVideoPlayerView;

@interface WXFloatFullScreenViewController : UIViewController

- (instancetype)initWithVideoPlayerView:(WXVideoPlayerView *)videoPlayerView;

@property (copy, nonatomic) void(^videoBackBlock)(WXVideoPlayerView *playerView);

@end

