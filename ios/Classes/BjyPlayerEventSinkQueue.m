//
//  BjyPlayerEventSinkQueue.m
//  flutter_bjyplayer
//
//  Created by 孙涛 on 2021/9/24.
//

#import "BjyPlayerEventSinkQueue.h"

@interface BjyPlayerEventSinkQueue ()

@property (nonatomic, strong) NSMutableArray *eventQueue;
@property (nonatomic, copy) FlutterEventSink eventSink;


@end

@implementation BjyPlayerEventSinkQueue

#pragma mark - public

- (void)success:(NSObject *)event
{
    [self enqueue:event];
    [self flushIfNeed];
}

- (void)setDelegate:(nullable FlutterEventSink)sink
{
    self.eventSink = sink;
}

- (void)error:(NSString *)code
      message:(NSString *_Nullable)message
      details:(id _Nullable)details
{
    [self enqueue:[FlutterError errorWithCode:code
                                      message:message
                                      details:details]];
    [self flushIfNeed];
}

#pragma mark -

- (instancetype)init
{
    if (self = [super init]) {
        _eventQueue = @[].mutableCopy;
    }
    
    return self;
}

- (void)flushIfNeed
{
    if (self.eventSink == nil) {
        return;
    }
    
    for (NSObject *obj in self.eventQueue) {
        self.eventSink(obj);
    }
    [self.eventQueue removeAllObjects];
}

- (void)enqueue:(NSObject *)event
{
    [self.eventQueue addObject:event];
}

@end
