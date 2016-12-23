//
//  SMEmitterButton.m
//  SMAninationGroup
//
//  Created by simon on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterButton.h"
#define kBoundsW self.bounds.size.width
#define kBoundsH self.bounds.size.height
@interface SMEmitterButton ()
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) NSMutableArray *keyPaths;

@property (nonatomic, strong) SMWareLayer *waveLayer;
@property (nonatomic, assign) SMEffectType effectType;

@end

@implementation SMEmitterButton

- (CAEmitterLayer *)emitterLayer {
    if (!_emitterLayer) {
        _emitterLayer = [CAEmitterLayer layer];
        _emitterLayer.name = @"emitterLayer";
        _emitterLayer.emitterShape = kCAEmitterLayerCircle;
        _emitterLayer.emitterMode = kCAEmitterLayerOutline;
        _emitterLayer.renderMode = kCAEmitterLayerOldestLast;
        _emitterLayer.masksToBounds = NO;
        _emitterLayer.zPosition = -1;
        _emitterLayer.position = CGPointMake(kBoundsW * 0.5, kBoundsH * 0.5);
        
        [self.layer addSublayer:_emitterLayer];
    }
    
    return _emitterLayer;
}

- (SMWareLayer *)waveLayer {
    if (!_waveLayer) {
        _waveLayer = [SMWareLayer layer];
        CGFloat diameter = kBoundsW;
        if (kBoundsH > kBoundsW) diameter = kBoundsH;
        _waveLayer.bounds = CGRectMake(0,0, diameter, diameter);
        _waveLayer.position = CGPointMake(kBoundsW * 0.5, kBoundsH * 0.5);
        _waveLayer.opacity = 0;
        _waveLayer.color = [UIColor blueColor];
        
        [self.layer insertSublayer:_waveLayer atIndex:0];
    }
    
    return _waveLayer;
}

- (NSMutableArray *)keyPaths {
    if (!_keyPaths) {
        _keyPaths = [NSMutableArray array];
    }
    
    return _keyPaths;
}

- (instancetype)initWithEffectType:(SMEffectType)effectType frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupWithEffectType:effectType];
    }
    
    return self;
}

- (void)setupWithEffectType:(SMEffectType)effectType {
    
    _effectType = effectType;
    
    switch (effectType) {
        case SMEffectEmitter:
            [self emitterLayer];
            break;
        case SMEffectWare:
            [self waveLayer];
            break;
        default:
            break;
    }
}

- (void)setWareColor:(UIColor *)wareColor {
    
    _wareColor = wareColor;
    
    if (_effectType == SMEffectEmitter) return;
    
    self.waveLayer.color = wareColor;
    [self.waveLayer setNeedsDisplay];
}

- (void)setWareType:(SMWareLayerType)wareType {
    _wareType = wareType;
    
    if (_effectType == SMEffectEmitter) return;
    self.waveLayer.wareType = wareType;
    [self.waveLayer setNeedsDisplay];
}

- (void)setEmitters:(NSArray<UIImage *> *)emitters {
    
    _emitters = emitters;
    if (_effectType == SMEffectWare) return;
    
    NSString *keyPath = nil;
    NSString *name = nil;
    NSMutableArray *emitterCells = [NSMutableArray array];
    
    for (int i = 0; i < emitters.count; i++) {
        UIImage *image = emitters[i];
        CAEmitterCell *emitter = [CAEmitterCell emitterCell];
        name = [NSString stringWithFormat:@"emitter%zd", i];
        keyPath = [NSString stringWithFormat:@"emitterCells.%@.birthRate", name];
        emitter.name = name;
        emitter.alphaRange = 0.10;
        emitter.alphaSpeed = -1.0;
        emitter.lifetime = 0.7;
        emitter.lifetimeRange = 0.3;
        emitter.velocity = 40.00;
        emitter.velocityRange = 5.00;
        emitter.scale = 0.1;
        emitter.scaleRange = 0.02;
        emitter.birthRate = 0;
        
        emitter.contents = (__bridge id _Nullable)image.CGImage;
        [emitterCells addObject:emitter];
        [self.keyPaths addObject:keyPath];
    }
    
    _emitterLayer.emitterCells = emitterCells;
}

// start animation
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];

    if (_effectType == SMEffectEmitter) {
        [self emitter];
    } else {
        [self wave];
    }
}

#pragma mark - emitter
- (void)emitter {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.25;
    
    if (self.isSelected) {
        scaleAnimation.values = @[@1.1, @1.3, @1.5, @1.2 , @1.0];
        
        [self startEmitter];
        
    } else {
        scaleAnimation.values = @[@0.8, @0.6, @0.8, @1.0];
    }
    
    scaleAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
}

- (void)startEmitter {
    for (NSString *keyPath in self.keyPaths) {
        [self.emitterLayer setValue:@1500 forKeyPath:keyPath];
    }
    self.emitterLayer.beginTime = CACurrentMediaTime();
    
    [self performSelector:@selector(stopEmitter) withObject:nil afterDelay:0.1];
}

- (void)stopEmitter {
    for (NSString *keyPath in self.keyPaths) {
        [self.emitterLayer setValue:@0 forKeyPath:keyPath];
    }
}

#pragma mark - wave
- (void)wave {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 0.25;
    
    if (self.isSelected) {
        scaleAnimation.values = @[@1.1, @1.3, @1.5, @1.2 , @1.0];
        
        [self startWare];
        
    } else {
        scaleAnimation.values = @[@0.8, @0.6, @0.8, @1.0];
    }
    
    scaleAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
    
    
}

-(void)startWare {
    
    NSTimeInterval duration = 1.6;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.2;
    scaleAnimation.toValue = @2.2;
    scaleAnimation.duration = duration;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = duration;
    opacityAnimation.fromValue = @0.7;
    opacityAnimation.toValue = @0;
    
    CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;
    animationGroup.repeatCount = 1;
    animationGroup.timingFunction = defaultCurve;
    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    [_waveLayer addAnimation:animationGroup forKey:@"wareAnimation"];
    
}

- (void)setHighlighted:(BOOL)highlighted{}
@end

@implementation SMWareLayer

- (instancetype)init {
    if (self = [super init]) {
        static CGFloat scale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scale = [UIScreen mainScreen].scale;
        });
        self.contentsScale = scale;
    }
    return self;
}

- (void)setNeedsDisplay {
    [self display];
}

- (void)display {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, self.contentsScale);
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    switch (self.wareType) {
        case SMWareLayerHeart:
            [self heart:path];
            break;
        case SMWareLayerCircle:
            [self circle:path];
            break;
        default:
            break;
    }
    
    // draw
    [[self color] setStroke];
    
    [path stroke];
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image.CGImage);
}

- (void)heart:(UIBezierPath *)path {
    CGFloat padding = 4.0;
    CGRect rect = self.bounds;
    CGFloat radius = floor((CGRectGetWidth(rect) - 2 * padding) / padding);
    
    // start point
    CGPoint point = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - padding);
    [path moveToPoint:point];
    
    //left curve ponit
    CGPoint leftPoint = CGPointMake(padding, floor(CGRectGetHeight(rect) / 2.4));
    [path addQuadCurveToPoint:leftPoint controlPoint:CGPointMake(leftPoint.x, leftPoint.y + radius)];
    [path addArcWithCenter:CGPointMake(leftPoint.x + radius, leftPoint.y) radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //right curve ponit
    CGPoint rightPoint = CGPointMake(leftPoint.x + 2 * radius, leftPoint.y);
    [path addArcWithCenter:CGPointMake(rightPoint.x + radius, rightPoint.y) radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //end point
    CGPoint endPoint = CGPointMake(leftPoint.x + 4 * radius, rightPoint.y);
    [path addQuadCurveToPoint:point controlPoint:CGPointMake(endPoint.x, endPoint.y + radius)];
    // setter
    path.lineWidth = 2;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
}

- (void)circle:(UIBezierPath *)path {
    
    [path addArcWithCenter:CGPointMake(kBoundsW * 0.5, kBoundsH * 0.5) radius:kBoundsH * 0.5 - 5  startAngle:0.0 endAngle:180.0 clockwise:YES];
    // setter
    path.lineWidth = 2;
    
}

@end
