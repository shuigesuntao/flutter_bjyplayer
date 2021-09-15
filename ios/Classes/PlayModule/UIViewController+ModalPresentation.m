//
//  UIViewController+ModalPresentation.m
//  ZYWXOnlineSchool
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 JackMac. All rights reserved.
//

#import "UIViewController+ModalPresentation.h"


@implementation UIViewController (ModalPresentation)

- (void)presentModalViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^__nullable)(void))completion{
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
