//
//  NSDictionary+Crash.m
//  smifun
//
//  Created by simon on 17/3/6.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "NSDictionary+Crash.h"
#import "SMIAvoidCrash.h"
@implementation NSDictionary (Crash)
+ (void)sm_avoidCrashExchangeMethod {

    [SMIAvoidCrash exchangeClassMethod:self method1Sel:@selector(dictionaryWithObjects:forKeys:count:) method2Sel:@selector(sm_dictionaryWithObjects:forKeys:count:)];
}

+ (instancetype)sm_dictionaryWithObjects:(const id  _Nonnull __unsafe_unretained *)objects forKeys:(const id<NSCopying>  _Nonnull __unsafe_unretained *)keys count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self sm_dictionaryWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        SLog(@"set a nil objec for NSDictionary %s%@",__func__,[exception callStackSymbols]);
        
        /// reInit
        NSUInteger index = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        id  _Nonnull __unsafe_unretained newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self sm_dictionaryWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}
@end
