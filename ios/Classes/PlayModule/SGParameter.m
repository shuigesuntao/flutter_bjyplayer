//
//  SGParameter.m
//  post
//
//  Created by liu chao on 15/10/8.
//  Copyright (c) 2015年 liu chao. All rights reserved.
//

#import "SGParameter.h"

@implementation SGParameter

- (SGHeader *)header {
    if (_header == nil) {
        _header = [[SGHeader alloc] init];
    }
    return _header;
}

@end
