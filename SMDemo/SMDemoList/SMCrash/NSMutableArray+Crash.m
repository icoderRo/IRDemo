//
//  NSMutableArray+Crash.m
//  smifun
//
//  Created by simon on 17/3/6.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "NSMutableArray+Crash.h"
#import "SMIAvoidCrash.h"
@implementation NSMutableArray (Crash)
+ (void)sm_avoidCrashExchangeMethod {
    
    Class smArrayClass = NSClassFromString(@"__NSArrayM");
    
    /// objectAtIndex:
    [SMIAvoidCrash exchangeInstanceMethod:smArrayClass method1Sel:@selector(objectAtIndex:) method2Sel:@selector(sm_objectAtIndexM:)];
    
    /// insertObject:atIndex:
    [SMIAvoidCrash exchangeInstanceMethod:smArrayClass method1Sel: @selector(insertObject:atIndex:) method2Sel:@selector(sm_insertObject:atIndex:)];
    
    /// setObject:atIndexedSubscript:
    [SMIAvoidCrash exchangeInstanceMethod:smArrayClass method1Sel: @selector(setObject:atIndexedSubscript:) method2Sel:@selector(sm_setObject:atIndexedSubscript:)];
    
    /// remove
    [SMIAvoidCrash exchangeInstanceMethod:smArrayClass method1Sel: @selector(removeObjectAtIndex:) method2Sel:@selector(sm_removeObjectAtIndex:)];
    
    /// getObjects:range:
       [SMIAvoidCrash exchangeInstanceMethod:smArrayClass method1Sel:@selector(getObjects:range:) method2Sel:@selector(sm_getObjects:range:)];
}

- (void)sm_setObject:(id)smObject atIndexedSubscript:(NSUInteger)index {
    
    @try {
        [self sm_setObject:smObject atIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableArray Set cross %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        
    }
}

- (void)sm_insertObject:(id)smObject atIndex:(NSUInteger)index {
    
    @try {
        [self sm_insertObject:smObject atIndex:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableArray Insert cross %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        
    }
}

- (id)sm_objectAtIndexM:(NSUInteger)index {
    
    id object = nil;
    
    @try {
        object = [self sm_objectAtIndexM:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableArray get cross %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        return object;
    }
}

- (void)sm_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self sm_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        SLog(@"NSMutableArray remove corss %s%@",__func__,[exception callStackSymbols]);

    }
    @finally {
        
    }
}

- (void)sm_getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)range {
    
    @try {
        
        [self sm_getObjects:objects range:range];
        
    } @catch (NSException *exception) {
        
        SLog(@"NSMutableArray getObjects cross %s%@",__func__,[exception callStackSymbols]);
    } @finally {
        
    }
}

@end
