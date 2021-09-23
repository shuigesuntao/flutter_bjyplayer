//
//  BjyPlayerEventSinkQueue.h
//  Pods
//
//  Created by 孙涛 on 2021/9/24.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface BjyPlayerEventSinkQueue : NSObject

- (void)success:(NSObject *)event;
- (void)setDelegate:(_Nullable FlutterEventSink)sink;

- (void)error:(NSString *)code
      message:(NSString *_Nullable)message
      details:(id _Nullable)details;

@end

NS_ASSUME_NONNULL_END
