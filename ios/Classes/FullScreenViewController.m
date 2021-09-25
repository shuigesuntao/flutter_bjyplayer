//
//  FullScreenViewController.m
//  flutter_bjyplayer
//
//  Created by 刘厚宽 on 2021/9/22.
//

#import "FullScreenViewController.h"
#import <BJVideoPlayerUI.h>
#import <BJLiveBase/BJLiveBase+UIKit.h>
#import <BJPUViewController+protected.h>
#import "FloatPlayerView.h"
@interface FullScreenViewController ()
@property (strong, nonatomic) BJPUViewController *playerUIVC;
@property (strong, nonatomic) NSString *vid;
@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) BOOL isNeedAD, mayDrag,isFloatView;

@end

@implementation FullScreenViewController
{
    UIView *topBarView;//顶部工具栏
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (instancetype)initWithVid:(NSString *)vid token:(NSString *)token isNeedAD:(BOOL)isNeedAD mayDrag:(BOOL)mayDrag
{
    self = [super init];
    if (self) {
        _vid = vid;
        _token = token;
        _isNeedAD = isNeedAD;
        _mayDrag = mayDrag;
    }
    return self;
}
- (instancetype)initWithVideoPlayer:(id)playerVC{
    self = [super init];
    NSLog(@"小窗全屏初始化");
    if (self) {
        self.playerUIVC = playerVC;
        _isFloatView = true;
        self.playerUIVC.view.userInteractionEnabled = true;
        [playerVC ExecuteHideBackIcon:false];
        [playerVC ExecuteHideBootomBar:false];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    // subview
    [self setupSubView];
  
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setNeedsUpdateConstraints];
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
    // playerView
    if (self.playerUIVC == nil) {
        BJPUVideoOptions *options = [BJPUVideoOptions new];
        options.autoplay = YES;
        options.playerType = BJVPlayerType_IJKPlayer;
        //options.backgroundAudioEnabled = YES;
        options.preferredDefinitionList = @[@"superHD", @"high", @"720p", @"1080p",@"low"];
        options.playTimeRecordEnabled = YES;
        options.encryptEnabled = NO;
        options.initialPlayTime = 0;
        options.userName = @"";
        options.userNumber = 0;
        options.playerType = BJVPlayerType_IJKPlayer;
        
        self.playerUIVC = [[BJPUViewController alloc] initWithVideoOptions:options];
        self.playerUIVC.layoutType = BJVPlayerViewLayoutType_Horizon;
        // play
        [self.playerUIVC playWithVid:_vid token:_token];
    }
    self.playerUIVC.playType = BJVPlayerViewScreenFullScreenType;
    [self bjl_addChildViewController:self.playerUIVC];
    [self.playerUIVC didMoveToParentViewController:self];
    __weak typeof(self) weakSelf = self;
    // 退出回调
    [self.playerUIVC setCancelCallback:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.playerUIVC bjl_removeFromParentViewControllerAndSuperiew];
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        [strongSelf dismissViewControllerAnimated:YES  completion:^{
            if (strongSelf->_isFloatView){
                [[FloatPlayerView shareFloatPlayerView]showInWindowFromVideoPlayer:strongSelf.playerUIVC];
            }else {
                [strongSelf.playerUIVC.playerManager destroy];
            }
        }];
    }];
    
    // 锁屏回调
    [self.playerUIVC setScreenLockCallback:^(BOOL locked) {
        
    }];
    [self.view addSubview:self.playerUIVC.view];
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
        if (self != nil){
            [self.playerUIVC.view bjl_remakeConstraints:^(BJLConstraintMaker *make) {
                make.edges.equalTo(self.view);
            }];
        }
    }
    else {
        [self.playerUIVC.view bjl_remakeConstraints:^(BJLConstraintMaker *make) {
            if (@available(iOS 11, *)) {
                make.top.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
            }
            else {
                make.top.equalTo(self.view).offset(20.0); // status bar
            }
            make.left.right.equalTo(self.view.bjl_safeAreaLayoutGuide ?: self.view);
            make.height.equalTo(self.playerUIVC.view.bjl_width).multipliedBy(9.0/16.0);
        }];
    }
}



- (void)click_live:(UIButton *)sender{
    
    NSLog(@"点击了");
    [self dismissViewControllerAnimated:YES  completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
    return UIInterfaceOrientationMaskLandscapeRight;
}

// 页面展示的时候默认屏幕方向（当前ViewController必须是通过模态ViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
