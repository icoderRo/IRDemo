//
//  SMICropMaskerView.m
//  smifun
//
//  Created by simon on 17/1/18.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMICropMaskerView.h"

@implementation SMICropMaskerView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    [clipPath appendPath:self.cropBoxPath];
    
    clipPath.usesEvenOddFillRule = YES;
    [clipPath addClip];
    
    if (!self.maskerColor) {
        self.maskerColor = [UIColor blackColor];
        CGContextSetAlpha(context, 0.3);
    }
    [self.maskerColor setFill];
    [clipPath fill];
}


@end
