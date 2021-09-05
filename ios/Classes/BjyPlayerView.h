//
//  BjyPlayerView.h
//  Pods
//
//  Created by Sun on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BjyPlayerView : NSObject<FlutterPlatformView>

+ (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id)args registrar:(id<FlutterPluginRegistrar>)registrar;

@end

NS_ASSUME_NONNULL_END

