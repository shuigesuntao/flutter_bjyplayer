//
//  Helper.h
//
//  Created by mac on 2018/4/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SCNetworkReachability.h>

@interface Helper : NSObject

+ (NSString *)filterHTML:(NSString *)html;


/*  字符串是否包含另一个字符串  */
+ (BOOL)stringBool:(NSString *)string subStr:(NSString *)substr;


// 文库name富文本
+ (NSAttributedString*)wenku_attributedString:(NSString *)str imageName:(NSString *)imageName imageFram:(CGRect)imageFram isFront:(BOOL)isFront;

/**
 图片富文本 图+文

 @param str str description
 @param imageName imageName description
 @param imageFram imageFram description
 @param isFront 图片是否在前面
 @return return value description
 */
+ (NSAttributedString*)attributedString:(NSString *)str imageName:(NSString *)imageName imageFram:(CGRect)imageFram isFront:(BOOL)isFront;

/**  图片富文本 文+图+文  */
+ (NSAttributedString*)attributedString:(NSString *)str imageName:(NSString *)imageName secondStr:(NSString *)secondStr secondStrColor:(UIColor *)secondStrColor imageFram:(CGRect)imageFram;

/*  去掉字符串最后一个字符  */
+ (NSString*)removeLastOneChar:(NSString*)origin;

/**  获取Window当前显示的ViewController  */
+ (UIViewController*)currentViewController;

/**  网页加载图片  */
+ (NSString *)htmlForJPGImage:(UIImage *)image;
/**
 collectionView 注册cell

 @param collectionView collectionView description
 @param ident ident description
 @param isNib isNib description
 */
+ (void)collectionViewRegistCellFrom:(UICollectionView *)collectionView  ident:(NSString *)ident isNib:(BOOL)isNib;

/**
 Description
 
 @param view 传入要变圆角的视图
 @param size 自己根据需要设置角度大小
 @param left left description
 @param right right description
 @param bottomLeft bottomLeft description
 @param bottomRight bottomRight description
 */
+ (void)drawRoundView:(UIView *)view size:(CGSize)size left:(BOOL)left right:(BOOL)right bottomLeft:(BOOL)bottomLeft bottomRight:(BOOL)bottomRight;


/**
  时间戳转时间格式

 @param str str description
 @return return value description
 */
+(NSString *)timeFromStr:(NSString *)str;

/**  价格富文本显示 带￥ */
+(NSAttributedString*)attributedJiaGe:(NSString *)str cgfl:(CGFloat)cgf1  cgf2:(CGFloat)cgf2 color:(UIColor *)color isInteger:(BOOL)integer;
//显示不同颜色和字体
+(NSAttributedString *)text:(NSString *)textStr value:(NSString *)valueStr color:(UIColor *)color font:(CGFloat)font;
+ (NSAttributedString*)wenku_attributedString:(NSString *)str imageFirstName:(NSString *)imageFirstName imageFirstFram:(CGRect)imageFirstFram imageSecondName:(NSString *)imageSecondName imageSecondFram:(CGRect)imageSecondFram isFront:(BOOL)isFront;

/**
 判断字符串是否为空
 @param aStr 字符串
 @return YES  空 NO
 */
+ (BOOL)isBlankString:(NSString *)aStr;
/**
 判断数组为空
 @param arr 数组
 @return YES 空 NO
 */
+ (BOOL)isBlankArr:(NSArray *)arr;
/**
 判断字典为空
 @param  dic 数组
 @return YES 空 NO
 */

+ (BOOL)isBlankDictionary:(NSDictionary *)dic;

/// 压缩图
/// @param imageData imageData
/// @param maxKB 最大KB
+ (NSData *)compressImage:(NSData *)imageData maxKB:(NSUInteger)maxKB;

+ (void)configStatusBarBackgroundColor:(UIColor *)color;
@end
