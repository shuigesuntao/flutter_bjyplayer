//
//  UIButton+WXScaleAction.h
//  WXOnlineSchool
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BJYScaleAction)
/**
 向外扩张button点击事件
 
 @param top 上
 @param right 右
 @param bottom 下
 @param left 左
 */
- (void)dh_setEnlargeEdgeWithTop:(CGFloat)top
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom
                            left:(CGFloat)left;
@end

NS_ASSUME_NONNULL_END
