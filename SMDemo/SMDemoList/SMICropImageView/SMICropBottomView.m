//
//  SMICropOperationView.m
//  smifun
//
//  Created by simon on 17/1/18.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMICropBottomView.h"

@interface SMICropBottomView ()
@end

@implementation SMICropBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _cancelBtn = [[UIButton alloc] init];
        
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:SMIValue(18)];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_cancelBtn];
        
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:SMIValue(18)];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sureBtn];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(SMIValue(40));
        make.centerY.equalTo(self);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-SMIValue(40));
        make.centerY.equalTo(self);
    }];
}

@end
