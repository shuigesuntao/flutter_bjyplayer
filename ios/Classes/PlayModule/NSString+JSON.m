//
//  NSString+JSON.m
//  AirPreparation
//
//  Created by Dong on 14-7-11.
//  Copyright (c) 2014年 aero-com. All rights reserved.
//

#import "NSString+JSON.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (JSON)

- (NSMutableDictionary *)jsonValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *er;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];
    return dic;
}

- (NSMutableDictionary *)jsonValueWithData:(NSData *)data{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    return [[NSMutableDictionary alloc] initWithDictionary:dic];
}

// 由数组获取日期字符串格式
- (NSString *)dataValueWithArray:(NSArray*)dataArray {
    NSString *str = [[NSString alloc] init];
    return str;
}

// 修改此处可以改变md5位数  16位、32位的md5    MD5算法 不管是什么语言得到的结果都是一样的。
- (NSString *)md5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5(cStr, [num intValue], result);
   
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04 
     */
}

- (NSString *)myMd5 {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];
    CC_MD5(cStr, [num intValue], result);
    NSString *str = [[NSString stringWithFormat:
                    @"%02X%02X%02X%02X%02X%02X%02X%02X",
                    result[4], result[5], result[6], result[7],
                    result[8], result[9], result[10], result[11]] lowercaseString];
    return str;
}

@end
