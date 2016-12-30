//
//  SMDanmakuLabel.m
//  SMAninationGroup
//
//  Created by simon on 16/12/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMDanmakuLabel.h"
#import <CoreText/CoreText.h>

NSString *const SMTextAttachmentToken = @"\uFFFC";

@implementation SMDanmakuLabel


- (void)drawRect:(CGRect)rect {
    
    // transform
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // frame
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // calculate
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    CGPoint lineOrigins[[lines count]];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    // get the image...
    
    
    CFRelease(framesetter);
    CFRelease(path);
    CFRelease(frame);
    
}

@end

@implementation NSMutableAttributedString (SMDanmakuText)

+ (NSMutableAttributedString *)attachmentStringWithImage:(UIImage *)image size:(CGSize)size font:(UIFont *)font {
    
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:SMTextAttachmentToken];
    
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat offsetY = font.ascender - fontHeight * 0.5;
    
    CGFloat ascent = size.height * 0.5 + offsetY;
    CGFloat descent = size.height - ascent;
    CGFloat width = size.width;
    
    NSDictionary *dict = @{@"ascent" : @(ascent),
                           @"descent" : @(descent),
                           @"width" : @(width)};
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.getAscent = getAscentCallback;
    callbacks.getDescent = getDescentCallback;
    callbacks.getWidth = getWidthCallback;
    CTRunDelegateRef delegateRef = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    [attrs setRunDelegate:delegateRef range:NSMakeRange(0, attrs.length)];
    if (delegateRef) CFRelease(delegateRef);
    
    return attrs;
    
}

#pragma mark - Attribute
- (void)setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    
    if (value && ![NSNull isEqual:value]) {
        [self addAttribute:name value:value range:range];
    }else {
        [self removeAttribute:name range:range];
    }
}

- (void)removeAttributesInRange:(NSRange)range {
    [self setAttributes:nil range:range];
}

static CGFloat getAscentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"ascent"] floatValue];
}

static CGFloat getDescentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"descent"] floatValue];;
}

static CGFloat getWidthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@end
