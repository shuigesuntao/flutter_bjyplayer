//
//  WXFloatFullScreenViewController.m
//  BJYWXOnlineSchool
//
//  Created by mac on 2019/10/18.
//  Copyright © 2019 JackMac. All rights reserved.
//
#import "WXFloatFullScreenViewController.h"
#import "WXVideoPlayerView.h"
#import "BJLiveBase+UIKit.h"

@interface WXFloatFullScreenViewController ()

@property (nonatomic,strong) WXVideoPlayerView  *fullPlayerView;

@end

@implementation WXFloatFullScreenViewController

- (void)dealloc {
    
}

- (instancetype)initWithVideoPlayerView:(WXVideoPlayerView *)videoPlayerView{
    
    self = [super init];
    if (self) {
       self.fullPlayerView = videoPlayerView;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
        [self.view setNeedsUpdateConstraints];
    } completion:nil];
}

#pragma mark - subViews

- (void)setupSubView {
    
    if (self.fullPlayerView) {
        [self.view addSubview:self.fullPlayerView];
        [self.fullPlayerView bjl_makeConstraints:^(BJLConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        __weak typeof(self) weakSelf = self;
        self.fullPlayerView.cancelCallback = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf clickBackAction];
        };
    }
   

}

#pragma mark - constraints

- (void)updateViewConstraints {
    CGSize size = self.view.bounds.size;
    BOOL isHorizontal = size.width > size.height;
    [self updateConstraintsForHorizontal:isHorizontal];
    [super updateViewConstraints];
}

- (void)updateConstraintsForHorizontal:(BOOL)isHorizontal {
    if (isHorizontal) {
        [self.fullPlayerView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    else {
        [self.fullPlayerView bjl_remakeConstraints:^(BJLConstraintMaker *make) {
            if (@available(iOS 11, *)) {
                make.top.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
            }
            else {
                make.top.equalTo(self.view).offset(20.0); // status bar
            }
            make.left.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
            make.height.equalTo(self.fullPlayerView.bjl_width).multipliedBy(9.0/16.0);
        }];
    }
}

- (void)clickBackAction{
    if (self.videoBackBlock) {
        self.videoBackBlock(self.fullPlayerView);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark - 屏幕方向控制
//  是否支持自动转屏
- (BOOL)shouldAutorotate{
    
    //    NSLog(@"是否允许横竖屏%d",[self.playerUIVC isLockedNow]);
    return NO;
}

// 支持哪些转屏方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

//页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
