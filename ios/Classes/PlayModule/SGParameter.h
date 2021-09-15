//
//  SGParameter.h
//  post
//
//  Created by liu chao on 15/10/8.
//  Copyright (c) 2015年 liu chao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGHeader.h"

@interface SGParameter : NSObject

///请求head
@property (nonatomic,strong) SGHeader *header;

///请求body
@property (nonatomic,strong) NSDictionary *body;


///状态码,返回结果用
@property (nonatomic,strong) NSNumber *code;



@end
