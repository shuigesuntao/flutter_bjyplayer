//
//  BJPUProgressView.m
//  BJVideoPlayerUI
//
//  Created by DLM on 2017/4/26.
//
//

#import <BJLiveBase/BJLiveBase+UIKit.h>

#import "BJPUProgressView.h"
#import "BJPUAppearance.h"

@interface BJPUProgressView ()

@property (nonatomic, strong) UIImageView *sliderBgView;
@property (nonatomic, strong) UIView *cacheView;

@end

@implementation BJPUProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO; // 解决警告
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    self.sliderBgView = nil;
    self.slider = nil;
}

#pragma mark - subViews

- (void)setupSubviews {
    // slideBgView
    [self addSubview:self.sliderBgView];
    [self.sliderBgView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self).offset(2.0);
        make.right.equalTo(self);
        make.centerY.equalTo(self);
        make.height.equalTo(@2.0);
    }];
    
    // cacheView
    [self addSubview:self.cacheView];
    [self.cacheView bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self.sliderBgView).offset(1.0);
        make.top.bottom.equalTo(self.sliderBgView);
        make.width.equalTo(@0.0);
    }];
    
    // slider
    [self addSubview:self.slider];
    [self.slider bjl_makeConstraints:^(BJLConstraintMaker *make) {
        make.left.equalTo(self).offset(1.0);
        make.centerY.equalTo(self).offset(-1.0);
        make.height.width.equalTo(self);
    }];
}

#pragma mark - public

- (void)setValue:(CGFloat)value cache:(CGFloat)cache duration:(CGFloat)duration {
    // slider
    self.slider.maximumValue = duration;
    self.slider.value = value;
    
    // cache
    if (duration) {
        CGFloat progressWidth = CGRectGetWidth(self.frame) - 3.0;
        CGFloat cacheF = cache / duration;
        [self.cacheView bjl_updateConstraints:^(BJLConstraintMaker *make) {
            make.width.equalTo(@(progressWidth * cacheF));
        }];
    }
}

#pragma mark - getters & setters

- (UIImageView *)sliderBgView {
    if (!_sliderBgView) {
        _sliderBgView = ({
            UIImage *image = [UIImage bjpu_imageNamed:@"ic_player_progress_gray_n.png"];
            UIImage *stretchImage = [image stretchableImageWithLeftCapWidth:4.0
                                                               topCapHeight:1.0];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:stretchImage];
            imageView.accessibilityLabel = BJLKeypath(self, sliderBgView);
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = 1.0;
            imageView;
        });
    }
    return _sliderBgView;
}

- (BJPUVideoSlider *)slider {
    if (!_slider) {
        _slider = ({
            BJPUVideoSlider *slider = [[BJPUVideoSlider alloc] init];
            slider.accessibilityLabel = BJLKeypath(self, slider);
            slider.backgroundColor = [UIColor clearColor];
            slider.minimumTrackTintColor = [UIColor clearColor];
            slider.maximumTrackTintColor = [UIColor clearColor];
            UIImage *leftStretch = [[UIImage bjpu_imageNamed:@"ic_player_progress_orange_n.png"]
                                    stretchableImageWithLeftCapWidth:4.0
                                    topCapHeight:1.0];
            [slider setMinimumTrackImage:leftStretch forState:UIControlStateNormal];
            [slider setThumbImage:[UIImage bjpu_imageNamed:@"ic_player_current_n.png"] forState:UIControlStateNormal];
            [slider setThumbImage:[UIImage bjpu_imageNamed:@"ic_player_current_big_n.png"] forState:UIControlStateHighlighted];
            slider;
        });
    }
    return _slider;
}

- (UIView *)cacheView {
    if (!_cacheView) {
        _cacheView = ({
            UIView *view = [[UIView alloc] init];
            view.accessibilityLabel = BJLKeypath(self, cacheView);
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 1.0;
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
    }
    return _cacheView;
}

@end

#pragma mark - custom slider

@implementation BJPUVideoSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    thumbRect.origin.x = (self.maximumValue > 0?(value / self.maximumValue * self.frame.size.width):0) - self.currentThumbImage.size.width / 2;
    thumbRect.origin.y = 0;
    thumbRect.size.height = bounds.size.height;
    return thumbRect;
}

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds {
    return CGRectZero;
}

- (CGRect)maximumValueImageRectForBounds:(CGRect)bounds {
    return CGRectZero;
}

@end
