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
        emitter.velocity = 30.00;
        emitter.velocityRange = 4.00;
        emitter.scale = 0.1;
        emitter.scaleRange = 0.02;
        emitter.contents = (__bridge id _Nullable)image.CGImage;
        
        [emitterCells addObject:emitter];
        [self.keyPaths addObject:keyPath];
    }

    _emitterLayer = [CAEmitterLayer layer];
    _emitterLayer.name = @"emitterLayer";
    _emitterLayer.emitterShape = kCAEmitterLayerCircle;
    _emitterLayer.emitterMode = kCAEmitterLayerOutline;
    _emitterLayer.emitterCells = emitterCells;
    _emitterLayer.renderMode = kCAEmitterLayerOldestFirst;
    _emitterLayer.masksToBounds = NO;
    _emitterLayer.zPosition = -1;
    _emitterLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    _emitterLayer.position = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);

    [self.layer addSublayer:_emitterLayer];
}

- (void)setSelected:(BOOL)selected {
    [self fire:selected];
}

- (void)fire:(BOOL)selected {
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.8, @1.0];
    scaleAnimation.duration = .2;
    
    if (selected) {
        
        for (NSString *keyPath in self.keyPaths) {
            [self.emitterLayer setValue:@(500) forKeyPath:keyPath];
        }
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (NSString *keyPath in self.keyPaths) {
                [self.emitterLayer setValue:@(0) forKeyPath:keyPath];
            }

            [super setSelected:selected];
        });
        
    } else {
        [super setSelected:selected];
    }
    scaleAnimation.calculationMode = kCAAnimationCubic;
    [self.layer addAnimation:scaleAnimation forKey:@"transform.scale"];
}

// cancel highlight
- (void)setHighlighted:(BOOL)highlighted{}

@end
