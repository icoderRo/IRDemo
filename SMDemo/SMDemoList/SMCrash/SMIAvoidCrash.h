//
//  SMIAvoidCrash.h
//  smifun
//
//  Created by simon on 17/3/10.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
@interface SMIAvoidCrash : NSObject
+ (void)openAvoidCrash;

+ (void)exchangeClassMethod:(Class)smClass
                 method1Sel:(SEL)method1Sel
                 method2Sel:(SEL)method2Sel;

+ (void)exchangeInstanceMethod:(Class)smClass
                    method1Sel:(SEL)method1Sel
                    method2Sel:(SEL)method2Sel;

/// 假设需要手机崩溃的统计信息, 可再此统一处理崩溃回调
@end
