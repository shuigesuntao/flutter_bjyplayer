//
//  FullScreenViewController.h
//  flutter_bjyplayer
//
//  Created by 刘厚宽 on 2021/9/22.
//

#import <UIKit/UIKit.h>
#import <BJVideoPlayerUI.h>

UIKIT_STATIC_INLINE UIViewController * _Nonnull CurrentViewController() {
    
    UIViewController *topViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        
        topViewController = ((UITabBarController *)topViewController).selectedViewController;
    }
    
    if ([topViewController presentedViewController]) {
        
        topViewController = [topViewController presentedViewController];
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
        
        return [(UINavigationController*)topViewController topViewController];
    }
    
    return topViewController;
}
NS_ASSUME_NONNULL_BEGIN

@interface FullScreenViewController : UIViewController
- (instancetype)initWithVid:(NSString *)vid token:(NSString *)token isNeedAD:(BOOL)isNeedAD mayDrag:(BOOL)mayDrag;

- (instancetype)initWithVideoPlayer:(BJPUViewController  *)playerVC;
@end

NS_ASSUME_NONNULL_END
