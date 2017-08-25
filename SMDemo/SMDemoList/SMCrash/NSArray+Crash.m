//
//  NSArray+Crash.m
//  smifun
//
//  Created by simon on 17/3/6.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "NSArray+Crash.h"
#import "SMIAvoidCrash.h"

@implementation NSArray (Crash)

+ (void)sm_avoidCrashExchangeMethod {
    
    Class __NSArray = NSClassFromString(@"NSArray");
    Class __NSArrayI = NSClassFromString(@"__NSArrayI");
    Class __NSSingleObjectArrayI = NSClassFromString(@"__NSSingleObjectArrayI");
    Class __NSArray0 = NSClassFromString(@"__NSArray0");
    
    /// arrayWithObjects:count:
    [SMIAvoidCrash exchangeClassMethod:[self class] method1Sel:@selector(arrayWithObjects:count:) method2Sel:@selector(sm_arrayWithObjects:count:)];
    /// arrayWithObject:
    [SMIAvoidCrash exchangeClassMethod:[self class] method1Sel:@selector(arrayWithObject:) method2Sel:@selector(sm_arrayWithObject:)];
    
    //objectAtIndex:
    [SMIAvoidCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(sm_NSArrayIAtIndexI:)];
    [SMIAvoidCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(objectAtIndex:) method2Sel:@selector(sm_NSSingleObjectArrayIAtIndexI:)];
    [SMIAvoidCrash exchangeInstanceMethod:__NSArray0 method1Sel:@selector(objectAtIndex:) method2Sel:@selector(sm_NSArray0AtIndexI:)];
    
    //getObjects:range:
    [SMIAvoidCrash exchangeInstanceMethod:__NSArray method1Sel:@selector(getObjects:range:) method2Sel:@selector(sm_getNSArrayObjects:range:)];
    [SMIAvoidCrash exchangeInstanceMethod:__NSSingleObjectArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(sm_getNSSingleObjectArrayIObjects:range:)];
    [SMIAvoidCrash exchangeInstanceMethod:__NSArrayI method1Sel:@selector(getObjects:range:) method2Sel:@selector(sm_getNSArrayIObjects:range:)];
}

+ (instancetype)sm_arrayWithObject:(const id  _Nonnull __unsafe_unretained *)object {
    
    id instance = nil;
    
    @try {
        instance = [self sm_arrayWithObject:object];
    }
    @catch (NSException *exception) {
        SLog(@"NSArray init nil %s%@",__func__,[exception callStackSymbols]);
    }
    @finally {
        return instance;
    }
}

+ (instancetype)sm_arrayWithObjects:(const id  _Nonnull __unsafe_unretained *)objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
        instance = [self sm_arrayWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        SLog(@"NSArray init nil %s%@",__func__,[exception callStackSymbols]);
        
        /// 删除为nil的数据
        NSInteger newObjsIndex = 0;
        id  _Nonnull __unsafe_unretained newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self sm_arrayWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

/// objectAtIndex:
- (id)sm_NSSingleObjectArrayIAtIndexI:(NSUInteger)index {

    id object = nil;
    
    @try {
        object = [self sm_NSSingleObjectArrayIAtIndexI:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSArray get cross %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        return object;
    }
}

- (id)sm_NSArrayIAtIndexI:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self sm_NSArrayIAtIndexI:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSArray get cross %s%@",__func__,[exception callStackSymbols]);
        
    }
    @finally {
        return object;
    }
}

- (id)sm_NSArray0AtIndexI:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self sm_NSArray0AtIndexI:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSArray get cross %s%@",__func__,[exception callStackSymbols]);
        
    }
    @finally {
        return object;
    }
}

///  getObjects:range:
- (void)sm_getNSSingleObjectArrayIObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self sm_getNSSingleObjectArrayIObjects:objects range:range];
    } @catch (NSException *exception) {
        
        SLog(@"NSArray getObjects:range cross %s%@",__func__,[exception callStackSymbols]);
        
    } @finally {
        
    }
}

- (void)sm_getNSArrayObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self sm_getNSArrayObjects:objects range:range];
    } @catch (NSException *exception) {
        
        SLog(@"NSArray getObjects:range cross %s%@",__func__,[exception callStackSymbols]);
        
    } @finally {
        
    }
}

- (void)sm_getNSArrayIObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        [self sm_getNSArrayIObjects:objects range:range];
    } @catch (NSException *exception) {
        
        SLog(@"NSArray getObjects:range cross %s%@",__func__,[exception callStackSymbols]);
        
    } @finally {
        
    }
}


@end
