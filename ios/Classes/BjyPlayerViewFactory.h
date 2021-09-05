//
//  BjyPlayerViewFactory.h
//  Pods
//
//  Created by Sun on 2021/9/5.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BjyPlayerViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithRegistrar:(id<FlutterPluginRegistrar>)registrar;

@end

NS_ASSUME_NONNULL_END
