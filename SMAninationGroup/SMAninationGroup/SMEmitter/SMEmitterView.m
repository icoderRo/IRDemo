//
//  SMEmitterView.m
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterView.h"

#define SMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define SMRandColor SMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define emitterWH 36

@interface SMEmitterView () <CAAnimationDelegate>

@property (nonatomic, strong) NSMutableSet *reusePool;
@property (nonatomic, strong) NSMutableArray *displayPool;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSUInteger emitterCount;
@property (nonatomic, assign) NSUInteger totalCount;

@property (nonatomic, assign) BOOL paused;


@end

@implementation SMEmitterView

#pragma mark - lazy
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(fire) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    
    return _timer;
}

- (NSMutableArray *)displayPool {
    if (!_displayPool) {
        _displayPool = [NSMutableArray array];
    }
    return _displayPool;
}

- (NSMutableSet *)reusePool {
    if (!_reusePool) {
        _reusePool = [NSMutableSet set];
    }
    return _reusePool;
}

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _emitterCount = 0;
        _totalCount = 0;
        _emitterSize = CGSizeMake(emitterWH, emitterWH);
    }
    
    return self;
}

- (void)fire {
    
    if (_emitterCount <= 0) {
        [self stop];
        return;
    }
    
    _emitterCount--;
//    NSLog(@"%zd", _emitterCount);
    SMEmitterLayer *layer = [self dequeueReuseLayer];
    [self.layer addSublayer:layer];
    [self.displayPool addObject:layer];
    
    // direction -1 / 1
    int direction = 1 - (2 * arc4random_uniform(2));
    CGPathRef path = [self pathWithDirection:direction];
    NSTimeInterval totalAnimationDuration = 7;
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = path;
    keyFrameAnimation.duration = totalAnimationDuration;
    
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 0.1 - 0.6
    CGFloat scaleRotate = (float)(1 + arc4random() % 6) / 10;
    rotationAnimation.values = @[@(0), @(M_PI_4 * direction * scaleRotate), @(-M_PI_4 * direction * scaleRotate)];
    rotationAnimation.duration = totalAnimationDuration;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(0.9);
    alphaAnimation.toValue = @(0);
    alphaAnimation.duration =totalAnimationDuration;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(0);
    scaleAnimation.toValue = @(1);
    scaleAnimation.duration = 0.2;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.repeatCount = 1;
    animationGroup.removedOnCompletion = NO;
    animationGroup.duration = totalAnimationDuration;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationGroup.animations = @[keyFrameAnimation, rotationAnimation,alphaAnimation, scaleAnimation];
    animationGroup.delegate = self;
    [layer addAnimation:animationGroup forKey:@"icoderRo.github.com"];
    
}

/// return animation path
- (CGPathRef)pathWithDirection:(int)direction {
    
    CGFloat centerX;
    CGFloat width = self.bounds.size.width;
    
    switch (_positionType) {
        case SMEmitterPositionCenter:
            centerX = width * 0.5;
            break;
        case SMEmitterPositionRight:
            centerX = width - _emitterSize.width - 15;
            if (centerX <= 0) {
                centerX = width * 0.5;
            }
            break;
            
        case SMEmitterPositionLeft:
             centerX = _emitterSize.width + 15;
            if (centerX <= 0) {
                centerX = width * 0.5;
            }
            break;
            
        default:
            break;
    }
    
    int random = arc4random_uniform(4);
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // startPoint
    CGFloat startY = self.bounds.size.height - random;
    CGFloat startX = centerX + (random * direction);
    CGPoint startPoint = CGPointMake(startX, startY);
    [path moveToPoint:startPoint];
    
    // control point
    random =  (arc4random() % 91) + 10;
    int randomY = (arc4random() % 91) + 15;
    
    CGFloat controlX1 = centerX - (direction * random);
    CGFloat controlY1 = self.bounds.size.height * 0.5 + (randomY * direction);
    CGPoint controlP1 = CGPointMake(controlX1, controlY1);
    
    CGFloat controlX2 = centerX + ((random - 12 )* direction);
    CGFloat controlY2 = controlY1;
    CGPoint controlP2 = CGPointMake(controlX2, controlY2);
    
    // endPoint
    randomY = (arc4random() % 21) + 15;
    random = (arc4random() % 15) + 15;
    CGFloat endY = randomY + direction;
    CGFloat endX = startX +(random * direction);
    CGPoint endPoint = CGPointMake(endX, endY);
    
    [path addCurveToPoint:endPoint controlPoint1:controlP1 controlPoint2:controlP2];
    
    return path.CGPath;
}

- (id)dequeueReuseLayer {
    
    SMEmitterLayer *layer = [self.reusePool anyObject];
    
    if (layer) {
        [self.reusePool removeObject:layer];
        return layer;
    }
    
    layer = [SMEmitterLayer layer];
    layer.frame = CGRectMake(0, 0, _emitterSize.width, _emitterSize.height);
    
    if (self.images.count > 0) {
        int random = arc4random_uniform((int)self.images.count);
        layer.contents = (__bridge id _Nullable)(((UIImage *)self.images[random]).CGImage);
        return layer;
    }
    
    [layer setNeedsDisplay];
    
    return layer;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    SMEmitterLayer *layer = self.displayPool.firstObject;
    [self.displayPool removeObject:layer];
    [layer removeAllAnimations];
    [layer removeFromSuperlayer];
    [self.reusePool addObject:layer];
    
    if (self.displayPool.count <= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.displayPool.count <= 0) {
                [self.reusePool removeAllObjects];
            }
        });
    }
}

#pragma mark - Fire

/**
 when enterBackground we call "pause" to stop animation,
 in the background, when we receive message,
 we only receive message, the view is dismiss so no need to animation,
 so when the view is showed and want to regain animation, must to call "resume"
 */
- (void)fireWithEmitterCount:(NSUInteger)emitterCount {
    _emitterCount += emitterCount;
    _totalCount += emitterCount;
    if (self.paused) return;
    [self timer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSUInteger count = 1;
    [self fireWithEmitterCount:count];
    if (self.delegate && [self.delegate respondsToSelector:@selector(emitterView:didAddEmitterCount:)]) {
        [self.delegate emitterView:self didAddEmitterCount:count];
    }
}

#pragma mark - Control
- (void)pause {
    self.paused = YES;
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime()
                                              fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
    [_timer invalidate];
    _timer = nil;
}

- (void)resume {
    if (!self.paused) return;
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime()
                                                  fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    self.paused = NO;
    [self timer];
}

- (void)stop {
    [_timer invalidate];
    _timer = nil;
    _emitterCount = 0;
}

- (NSUInteger)totalCount {
    return _totalCount;
}

- (void)dealloc {
    [self stop];
}
@end


@interface SMEmitterLayer ()

@end

@implementation SMEmitterLayer

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
    
    CGFloat padding = 4.0;
    CGRect rect = self.bounds;
    CGFloat radius = floor((CGRectGetWidth(rect) - 2 * padding) / padding);
    
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // start point
    CGPoint point = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - padding);
    [path moveToPoint:point];
    
    //left curve ponit
    CGPoint leftPoint = CGPointMake(padding, floor(CGRectGetHeight(rect) / 2.4));
    [path addQuadCurveToPoint:leftPoint controlPoint:CGPointMake(leftPoint.x, leftPoint.y + radius)];
    [path addArcWithCenter:CGPointMake(leftPoint.x + radius, leftPoint.y) radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //right curve ponit
    CGPoint rightPoint = CGPointMake(leftPoint.x + 2*radius, leftPoint.y);
    [path addArcWithCenter:CGPointMake(rightPoint.x + radius, rightPoint.y) radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    //end point
    CGPoint endPoint = CGPointMake(leftPoint.x + 4*radius, rightPoint.y);
    [path addQuadCurveToPoint:point controlPoint:CGPointMake(endPoint.x, endPoint.y + radius)];
    
    // setter
    path.lineWidth = 1;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    // draw
    [[UIColor whiteColor] setStroke];
    [SMRandColor setFill];
    [path fill];
    [path stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image.CGImage);
}
@end
