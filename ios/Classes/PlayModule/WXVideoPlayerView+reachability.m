//
//  WXVideoPlayerView+reachability.m
//  BJPlayerManagerUI_Example
//
//  Created by mac on 2019/6/29.
//  Copyright © 2019年 oushizishu. All rights reserved.
//

#import "WXVideoPlayerView+reachability.h"
#import "MBProgressHUD+bjp.h"
#import "WXVideoPlayerView+PublicHeader.h"

@implementation WXVideoPlayerView (reachability)

- (void)setupReachabilityManager {
    self.reachablityManager = ({
        __block BOOL WWANNetworkShowed = NO;
        BJLAFNetworkReachabilityManager *manager = [BJLAFNetworkReachabilityManager manager];
        bjl_weakify(self);
        [manager setReachabilityStatusChangeBlock:^(BJLAFNetworkReachabilityStatus status) {
            bjl_strongify(self);
            if (status == BJLAFNetworkReachabilityStatusReachableViaWiFi) {
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (status == BJLAFNetworkReachabilityStatusReachableViaWiFi) {
                    return;
                }
                
                if (status == BJLAFNetworkReachabilityStatusUnknown
                    || status == BJLAFNetworkReachabilityStatusNotReachable) {
                    UIAlertController *alert = [UIAlertController
                                                alertControllerWithTitle:@"提示"
                                                message:@"网络连接已断开"
                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert bjl_addActionWithTitle:@"知道了"
                                            style:UIAlertActionStyleCancel
                                          handler:nil];
                   // [self presentViewController:alert animated:YES completion:nil];
                }
                
                if (status == BJLAFNetworkReachabilityStatusReachableViaWWAN) {
                    if (WWANNetworkShowed) {
                        [BJLProgressHUD bjp_showMessageThenHide:@"正在使用3G/4G网络" toView:self.playerManager.playerView onHide:nil];
                    }
                    else {
                        UIAlertController *alert = [UIAlertController
                                                    alertControllerWithTitle:@"提示"
                                                    message:@"正在使用3G/4G网络"
                                                    preferredStyle:UIAlertControllerStyleAlert];
                        [alert bjl_addActionWithTitle:@"知道了"
                                                style:UIAlertActionStyleCancel
                                              handler:nil];
                        //[self presentViewController:alert animated:YES completion:nil];
                    }
                }
            });
        }];
        manager;
    });
    [self.reachablityManager startMonitoring];
}

@end
