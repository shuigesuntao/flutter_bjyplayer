//
//  UIViewController+ModalPresentation.h
//  ZYWXOnlineSchool
//
//  Created by mac on 2019/10/14.
//  Copyright © 2019 JackMac. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface UIViewController (ModalPresentation)

- (void)presentModalViewController:(UIViewController *_Nonnull)viewControllerToPresent animated:(BOOL)flag completion:(void (^__nullable)( void))completion;

@end

