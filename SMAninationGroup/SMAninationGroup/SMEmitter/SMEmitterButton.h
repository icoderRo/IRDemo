//
//  SMEmitterButton.h
//  SMAninationGroup
//
//  Created by simon on 16/12/21.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMEmitterButton : UIButton

/**
 creat

 @param emitters an array load UIImage
 @param frame frame
 @return SMEitterBUtton
 */
- (instancetype)initWithEmitters:(NSArray<UIImage *> *)emitters frame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)buttonWithType:(UIButtonType)buttonType UNAVAILABLE_ATTRIBUTE;
@end
