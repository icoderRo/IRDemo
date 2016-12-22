//
//  SMEmitterButton.m
//  SMAninationGroup
//
//  Created by simon on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterButton.h"

@interface SMEmitterButton ()
@property (nonatomic, strong) CAEmitterLayer *emitterLayer;
@property (nonatomic, strong) NSMutableArray *keyPaths;

@end

@implementation SMEmitterButton

- (NSMutableArray *)keyPaths {
    if (!_keyPaths) {
        _keyPaths = [NSMutableArray array];
    }
    
    return _keyPaths;
}

- (instancetype)initWithEmitters:(NSArray<UIImage *> *)emitters frame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupEmitters:emitters];
    }
    
    return self;
}

- (void)setupEmitters:(NSArray<UIImage *> *)emitters {
    
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
    
    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.name = @"emitterLayer";
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.emitterCells = emitterCells;
    _emitterLayer.renderMode = kCAEmitterLayerOldestLast;
    _emitterLayer.masksToBounds = NO;
    _emitterLayer.zPosition = -1;
    _emitterLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    [self.layer addSublayer:_emitterLayer];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self fire:selected];
}

- (void)fire:(BOOL)selected {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
         scaleAnimation.duration = 0.25;
    if (selected) {
        scaleAnimation.values = @[@1.1, @1.3, @1.5, @1.2 , @1.0];
   
        [self start];
        
    } else {
        scaleAnimation.values = @[@0.8, @0.6, @0.8, @1.0];

    }
    
    scaleAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
}

- (void)start {
    for (NSString *keyPath in self.keyPaths) {
        [self.emitterLayer setValue:@1500 forKeyPath:keyPath];
    }
    self.emitterLayer.beginTime = CACurrentMediaTime();
    
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

- (void)stop {
    for (NSString *keyPath in self.keyPaths) {
        [self.emitterLayer setValue:@0 forKeyPath:keyPath];
    }
}

// cancel highlight
- (void)setHighlighted:(BOOL)highlighted{}

@end
