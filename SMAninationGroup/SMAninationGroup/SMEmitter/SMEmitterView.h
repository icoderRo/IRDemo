//
//  SMEmitterView.h
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMEmitterView;
@interface SMEmitterLayer : CALayer
@end

typedef NS_ENUM(NSUInteger, SMEmitterPositionType) {
    SMEmitterPositionCenter = 0,
    SMEmitterPositionRight = 1,
    SMEmitterPositionLeft = 2,
};

@protocol SMEmitterViewDelegate <NSObject>

@optional

/// Listening to self click event
- (void)emitterView:(SMEmitterView *)emitterView didAddEmitterCount:(NSUInteger)emitterCount;

@end

@interface SMEmitterView : UIView

/** 
    use: "- (void)fireWithEmitterCount:(NSUInteger)emitterCount"
    to start fire
    
    if set the "images" then use image, otherwise use default drawHeart
 
    warning: when enterBackground we call "pause" to stop animation,
             in the background, when we receive message,
             we only receive message, the view is dismiss and no need to animation,
             so when the view is showed and want to regain animation, must to call "resume"
 */


/**
 open fire and add the conut to current fire

 @param emitterCount "need add count to current fire"
 */
- (void)fireWithEmitterCount:(NSUInteger)emitterCount;


/**
 the emitter use image

 images: UIImage array
 */
@property (nonatomic, strong) NSArray *images;


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
@property (nonatomic, assign) CGSize emitterSize;


/**
 delegate: return emitters by self
 */
@property (nonatomic, weak) id<SMEmitterViewDelegate> delegate;


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
