//
//  SMEmitterButton.h
//  SMAninationGroup
//
//  Created by simon on 16/12/20  <https://github.com/icoderRo/SMAnimationDemo>
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SMEffectType) {
    SMEffectEmitter = 0, 
    SMEffectWare = 1,
};

typedef NS_ENUM(NSUInteger, SMWareLayerType) {
    SMWareLayerCircle = 0,
    SMWareLayerHeart = 1,
};

/// only SMEffectType == SMEffectWare
@interface SMWareLayer : CALayer

@property (nonatomic, assign) SMWareLayerType wareType;
@property (nonatomic, strong) UIColor *color;

@end

@interface SMEmitterButton : UIButton

/**
 creat method
 
 effectType: use "SMEffectEmitter" or "SMEffectWare"
 warn: if SMEffectType == SMEffectEmitter, must set "emitters"
 
 @param frame frame
 @return SMEitterBUtton
 */
- (instancetype)initWithEffectType:(SMEffectType)effectType frame:(CGRect)frame;


/// default is blueColor
@property (nonatomic, strong) UIColor *wareColor;


/// only SMEffectType == SMEffectEmitter
@property (nonatomic, assign) SMWareLayerType wareType;


/// warn: if SMEffectType == SMEffectEmitter, must "set"
@property (nonatomic, strong) NSArray<UIImage *> *emitters;


- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;

+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)buttonWithType:(UIButtonType)buttonType UNAVAILABLE_ATTRIBUTE;

@end
