//
//  BjyPlayerPlugin.m
//  Pods
//
//  Created by 孙涛 on 2021/9/5.
//

#import "BjyPlayerPlugin.h"
#import "BjyPlayerViewFactory.h"
#import <BJVideoPlayerUI.h>
#import "FullScreenViewController.h"

@interface BjyPlayerPlugin ()

@property (nonatomic, strong) NSObject<FlutterPluginRegistrar>* registrar;

@end

@implementation BjyPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bjy_player"
            binaryMessenger:[registrar messenger]];
  BjyPlayerPlugin* instance = [[BjyPlayerPlugin alloc] initWithRegistrar:registrar];
  [registrar addMethodCallDelegate:instance channel:channel];
  [registrar registerViewFactory:[[BjyPlayerViewFactory alloc] initWithRegistrar:registrar] withId:@"bjy_player_view"];
}

- (instancetype)initWithRegistrar:
    (NSObject<FlutterPluginRegistrar> *)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}


- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if([@"gotoFullScreenPage" isEqualToString:call.method]){
      NSDictionary *args = call.arguments;
      NSString *videoId = args[@"videoId"];
      NSString *token = args[@"token"];
      //TODO: 跳转全屏播放原生页面 参数为 videoId token
      
      FullScreenViewController *playerVC = [[FullScreenViewController alloc] initWithVid:videoId token:token isNeedAD :NO mayDrag:YES];

      playerVC.modalPresentationStyle = UIModalPresentationFullScreen;
      [CurrentViewController() presentViewController:playerVC animated:YES completion:nil];
  }else {
    result(FlutterMethodNotImplemented);
  }
}


@end
