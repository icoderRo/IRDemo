//
//  NSMutableDictionary+Crash.m
//  smifun
//
//  Created by simon on 17/3/6.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "NSMutableDictionary+Crash.h"
#import "SMIAvoidCrash.h"
@implementation NSMutableDictionary (Crash)
+ (void)sm_avoidCrashExchangeMethod {
     Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    /// set
    [SMIAvoidCrash exchangeInstanceMethod:dictionaryM method1Sel:@selector(setObject:forKey:) method2Sel:@selector(sm_setObject:forKey:)];
    
    /// remove
    [SMIAvoidCrash exchangeInstanceMethod:dictionaryM method1Sel:@selector(removeObjectForKey:) method2Sel:@selector(sm_removeObjectForKey:)];
}

- (void)sm_removeObjectForKey:(id<NSCopying>)key {
    
    @try {
        [self sm_removeObjectForKey:key];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableDictionary remove a null key %s%@",__func__,[exception callStackSymbols])
    }
    @finally {
        
    }
}

- (void)sm_setObject:(id)smObject forKey:(id<NSCopying>)key {
    
    @try {
        [self sm_setObject:smObject forKey:key];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableDictionary set a nil object %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        
    }
}
@end
