//
//  NSNull+Crash.m
//  smifun
//
//  Created by simon on 17/3/6.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "NSNull+Crash.h"

@implementation NSNull (Crash)
+ (void)sm_avoidCrashExchangeMethod {

    [SMIAvoidCrash exchangeInstanceMethod:self method1Sel:@selector(methodSignatureForSelector:) method2Sel:@selector(sm_methodSignatureForSelector:)];
    
    [SMIAvoidCrash exchangeInstanceMethod:self method1Sel:@selector(forwardInvocation:) method2Sel:@selector(sm_forwardInvocation:)];
}

- (NSMethodSignature *)sm_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self sm_methodSignatureForSelector:aSelector];
    if (sig) {return sig;}
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)sm_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {return;}
    
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    
    [anInvocation setReturnValue:buffer];
}
@end
