//
//  SMDanmakuLabel.m
//  SMAninationGroup
//
//  Created by simon on 16/12/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMDanmakuLabel.h"
#import <CoreText/CoreText.h>

@implementation SMDanmakuLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CFMutableAttributedStringRef attrs = (__bridge CFMutableAttributedStringRef)self.attributedText;

//    CTFontRef font = CTFontCreateWithName(string, 22, NULL);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
//    CFStringRef keys[] = {kCTFontAttributeName};
//    CFTypeRef values[] = {font};
//    
//    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys, (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
//    CFAttributedStringRef attriString = CFAttributedStringCreate(kCFAllocatorDefault, string, attributes);
    CTLineRef line = CTLineCreateWithAttributedString(attrs);
    
    CGContextSetTextPosition(context, 1.0, self.bounds.size.height - 22);
    CTLineDraw(line, context);
    
    CFRelease(line);
}

@end
