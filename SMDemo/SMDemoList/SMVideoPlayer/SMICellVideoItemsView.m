//
//  SMICellVideoItemsView.m
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

/// 小控件
#import "SMICellVideoItemsView.h"

@interface SMICellVideoItemsView ()
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *playOrPauseBtn;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UIButton *orientationBtn;
@end

@implementation SMICellVideoItemsView

- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:@"sliderVideo"] forState:UIControlStateNormal];
        [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
        [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
        [_progressSlider addTarget:self action:@selector(sliderValueChange) forControlEvents:UIControlEventValueChanged];
        [_progressSlider addTarget:self action:@selector(startSlider) forControlEvents:UIControlEventTouchDown];
        [_progressSlider addTarget:self action:@selector(slider) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_progressSlider];
    }
    
    return _progressSlider;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [[UIButton alloc] init];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:[UIImage imageNamed:@"shape"] forState:UIControlStateSelected];
        [_playOrPauseBtn addTarget:self action:@selector(clickPlayOrPauseBtn) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_playOrPauseBtn];
    }
    
    return _playOrPauseBtn;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [UILabel new];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12];
        _totalTimeLabel.textColor = HEXCOLOR(0xffffff);
        _totalTimeLabel.text = @"00:00";
        [_totalTimeLabel sizeToFit];
        [self addSubview:_totalTimeLabel];
    }
    
    return _totalTimeLabel;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [UILabel new];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12];
        _currentTimeLabel.textColor = HEXCOLOR(0xffffff);
        _currentTimeLabel.text = @"00:00";
        [_currentTimeLabel sizeToFit];
        [self addSubview:_currentTimeLabel];
    }
    
    return _currentTimeLabel;
}

- (UIButton *)orientationBtn {
    if (!_orientationBtn) {
        _orientationBtn = [[UIButton alloc] init];
        [_orientationBtn setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
        [_orientationBtn setImage:[UIImage imageNamed:@"guanbiquanpin"]forState:UIControlStateSelected];
        [_orientationBtn addTarget:self action:@selector(switchOrientation:) forControlEvents:UIControlEventTouchUpInside];
        [_orientationBtn.titleLabel setFont:[UIFont systemFontOfSize:30]];
        [_orientationBtn setTitle:@"   " forState:UIControlStateNormal];
        [_orientationBtn setTitle:@"   " forState:UIControlStateSelected];
        [self addSubview:_orientationBtn];
    }
    
    return _orientationBtn;
}

- (void)clickPlayOrPauseBtn {
    if ([self.delegate respondsToSelector:@selector(itemsView:didClickStartPlay:)]) {
        self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
        [self.delegate itemsView:self didClickStartPlay:!self.playOrPauseBtn.isSelected];
    }
}

- (void)switchOrientation:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(itemsView:didClickOrientationWithLandscape:)]) {
        sender.selected = !sender.isSelected;
        [self.delegate itemsView:self didClickOrientationWithLandscape:sender.selected];
    }
}

- (void)slider {
    if ([self.delegate respondsToSelector:@selector(itemsView:didSliderWithValue:)]) {
        [self.delegate itemsView:self didSliderWithValue:self.progressSlider.value];
    }
}

- (void)startSlider {
    if ([self.delegate respondsToSelector:@selector(itemsViewDidStartSlider:)]) {
        self.playOrPauseBtn.selected = YES;
        [self.delegate itemsViewDidStartSlider:self];
    }
}

- (void)sliderValueChange {
    if ([self.delegate respondsToSelector:@selector(itemsView:didDragSliderWithValue:)]) {
        [self.delegate itemsView:self didDragSliderWithValue:self.progressSlider.value];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(16);
        make.bottom.equalTo(self).offset(-11);
    }];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-50);
        make.bottom.equalTo(self).offset(-11);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(54);
        make.right.equalTo(self).offset(-90);
        make.centerY.equalTo(_totalTimeLabel);
    }];
    
    [self.playOrPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self.orientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.centerY.equalTo(_totalTimeLabel);
    }];
}

@end
