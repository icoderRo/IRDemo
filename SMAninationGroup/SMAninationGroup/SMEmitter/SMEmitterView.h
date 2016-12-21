//
//  SMEmitterView.h
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SMEmitterLayer : CALayer
@end

typedef NS_ENUM(NSUInteger, SMEmitterPositionType) {
    SMEmitterPositionCenter = 0,
    SMEmitterPositionRight = 1,
    SMEmitterPositionLeft = 2,
};

@interface SMEmitterView : UIView

/**
 the position of emitters style
 */
@property (nonatomic, assign) SMEmitterPositionType positionType;


/**
  return total emitter count 
 */
@property (nonatomic, assign, readonly) NSUInteger totalCount;


/**
 the emitters size, default is 36 
 */
@property (nonatomic, assign) CGSize size;


/**
 open fire and add the conut to current fire

 @param emitterCount "need add count to current fire"
 */
- (void)fireWithEmitterCount:(NSUInteger)emitterCount;


/**
 if need pause, then pause animation
 */
- (void)pause;


/**
 if pause, then you can resume animation
 */
- (void)resume;


/**
 if need dealloc, then stop
 */
- (void)stop;

@end
