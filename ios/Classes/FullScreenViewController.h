//
//  FullScreenViewController.h
//  flutter_bjyplayer
//
//  Created by 刘厚宽 on 2021/9/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FullScreenViewController : UIViewController
- (instancetype)initWithVid:(NSString *)vid token:(NSString *)token isNeedAD:(BOOL)isNeedAD mayDrag:(BOOL)mayDrag;

@end

NS_ASSUME_NONNULL_END
