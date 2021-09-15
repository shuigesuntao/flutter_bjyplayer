//
//  WXPlayOptionsManager.m
//  WXOnlineSchool
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "WXPlayOptionsManager.h"

static NSString * const videoOptionsKey = @"video_options";
static NSString * const playbackOptionsKey = @"playback_options";

@implementation WXPlayOptionsManager
#pragma mark - BJPUVideoOptions 点播设置

+ (void)setVideoOptions:(BJPUVideoOptions *)videoOptions{
    id jsonObject = [videoOptions bjlyy_modelToJSONObject];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:jsonObject forKey:videoOptionsKey];
    [userDefaults synchronize];
}

+ (BJPUVideoOptions *)getVideoOptions{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    id jsonObject = [userDefaults objectForKey:videoOptionsKey];
    BJPUVideoOptions * options = [BJPUVideoOptions new];
    options.autoplay = YES;
    options.playerType = BJVPlayerType_IJKPlayer;
    //options.backgroundAudioEnabled = YES;
    options.preferredDefinitionList = @[@"superHD", @"high", @"720p", @"1080p",@"low"];
    options.playTimeRecordEnabled = YES;
    return [BJPUVideoOptions bjlyy_modelWithJSON:jsonObject] ?: options;
}

@end
