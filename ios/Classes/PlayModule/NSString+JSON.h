//
//  NSString+JSON.h
//  AirPreparation
//
//  Created by Dong on 14-7-11.
//  Copyright (c) 2014年 aero-com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JSON)

- (NSMutableDictionary *)jsonValue;

// 由数组获取日期字符串格式
- (NSString *)dataValueWithArray:(NSArray *)dataArray;

// -(NSMutableDictionary *)jsonValueWithData:(NSData *)data;

/**
 32位的md5值
 */
- (NSString *)md5;

- (NSString *)myMd5;

@end
