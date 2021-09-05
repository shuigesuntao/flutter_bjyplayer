//
//  BjyPlayerViewFactory.m
//  Pods
//
//  Created by Sun on 2021/9/5.
//

#import "BjyPlayerViewFactory.h"
#import "BjyPlayerView.h"


@interface BjyPlayerViewFactory ()

@property (nonatomic, strong) id<FlutterPluginRegistrar> registrar;

@end

@implementation BjyPlayerViewFactory

- (instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar{
    if (self = [self init]) {
        _registrar = registrar;
    }
    
    return self;
}

#pragma mark - FlutterPlatformViewFactory

- (nonnull NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    return [BjyPlayerView createWithFrame:frame viewIdentifier:viewId arguments:args registrar:self.registrar];
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec
{
    return FlutterStandardMessageCodec.sharedInstance;
}

@end
