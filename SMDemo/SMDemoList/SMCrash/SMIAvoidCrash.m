//
//  SMIAvoidCrash.m
//  smifun
//
//  Created by simon on 17/3/10.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMIAvoidCrash.h"
#import "NSNull+Crash.h"
#import "NSArray+Crash.h"
#import "NSDictionary+Crash.h"
#import "NSMutableArray+Crash.h"
#import "NSMutableDictionary+Crash.h"
#import "NSNull+Crash.h"

@implementation SMIAvoidCrash
+ (void)openAvoidCrash {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSArray sm_avoidCrashExchangeMethod];
        [NSMutableArray sm_avoidCrashExchangeMethod];
        [NSDictionary sm_avoidCrashExchangeMethod];
        [NSMutableDictionary sm_avoidCrashExchangeMethod];
//        [NSNull sm_av]
    });
    
}

+ (void)exchangeClassMethod:(Class)smClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    Method method1 = class_getClassMethod(smClass, method1Sel);
    Method method2 = class_getClassMethod(smClass, method2Sel);
    method_exchangeImplementations(method1, method2);
}

+ (void)exchangeInstanceMethod:(Class)smClass method1Sel:(SEL)method1Sel method2Sel:(SEL)method2Sel {
    
    Method originalMethod = class_getInstanceMethod(smClass, method1Sel);
    Method swizzledMethod = class_getInstanceMethod(smClass, method2Sel);
    
    BOOL addMethod = class_addMethod(smClass, method1Sel, method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    
    if (addMethod) {
        class_replaceMethod(smClass, method2Sel, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
