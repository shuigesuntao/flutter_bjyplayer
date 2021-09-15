//
//  BJPUAppearance.h
//  BJVideoPlayerUI
//
//  Created by DLM on 2017/4/26.
//
//

#import <Foundation/Foundation.h>
#import <BJLiveBase/BJLiveBase+UIKit.h>
#import "MBProgressHUD+bjp.h"

static inline BOOL BJPUIsHorizontalUI(id<UITraitEnvironment> traitEnvironment) {
    return !(traitEnvironment.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact
             && traitEnvironment.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular);
}

@interface UIColor (BJPU)

+ (UIColor *)bjpu_colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)bjpu_colorWithHexString:(NSString *)color;

+ (instancetype)bjpu_brandColor;

@end

@interface UIImage (BJPU)

+ (UIImage *)bjpu_imageNamed:(NSString *)name;

@end

@interface NSString (BJPU)

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval;

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval totalTimeInterval:(NSTimeInterval)total;
@end
