//
//  SMICropViewController.h
//  smifun
//
//  Created by simon on 17/1/17.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

typedef NS_ENUM(NSUInteger, SMICropViewType) {
    SMICropViewTypeRectangle,
    SMICropViewTypeSquare,
};

#import <UIKit/UIKit.h>

@interface SMICropViewController : UIViewController
@property (nonatomic, strong) UIImage *sourceImage;
@property (nonatomic, copy) void (^imageHandle)(UIImage *image);
@property (nonatomic, assign) SMICropViewType cropType;

@end
