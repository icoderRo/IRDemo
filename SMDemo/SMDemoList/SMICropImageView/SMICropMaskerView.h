//
//  SMICropMaskerView.h
//  smifun
//
//  Created by simon on 17/1/18.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMICropMaskerView : UIView
/// 蒙版颜色
@property (nonatomic, strong) UIColor *maskerColor;
/// 裁剪框
@property (nonatomic, strong) UIBezierPath *cropBoxPath;
@end
