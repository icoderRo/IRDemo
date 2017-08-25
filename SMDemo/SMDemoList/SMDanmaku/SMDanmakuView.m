//
//  SMDanmakuView.m
//  SMAninationGroup
//
//  Created by simon on 17/1/3.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "SMDanmakuView.h"

NSString *const SMTextAttachmentAttributeName = @"SMTextAttachment";
NSString *const SMTextAttachmentToken = @"\uFFFC";

#warning 后面提供接口, 自行设置
CGFloat const margin = 10;

@implementation SMDanmakuView

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    if (!backgroundImage) return;
    
    _backgroundImage = backgroundImage;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundImage];
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
}

- (void)fireWithAttributedText:(NSMutableAttributedString *)attributedText {
    if (attributedText.length <= 0) return;
    
    SMDanmakuLayer *layer = [[SMDanmakuLayer alloc] init];
    // TODO:
    layer.frame = CGRectMake(0, 0, 500, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.backgroundImage = _danmakuBackgroundImage;
    layer.attributedText = attributedText.mutableCopy;
    [layer setNeedsDisplay];
    [self.layer addSublayer:layer];
}

@end

@implementation SMDanmakuLayer
- (instancetype)init {
    if (self = [super init]) {
        static CGFloat scale;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            scale = [UIScreen mainScreen].scale;
        });
        self.contentsScale = scale;
    }
    return self;
}

- (void)setNeedsDisplay {
    [self display];
}

- (void)display {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size , self.opaque, self.contentsScale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CGSize suggestSize;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_attributedText);
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    // 横屏不对
    if (width > kScreenW) width = kScreenW;
    CGSize constraints = CGSizeMake(ceil(width), ceil(height));
    {
        CGRect rect = {self.bounds.origin, constraints};
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, rect);
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        
        CFArrayRef lines = CTFrameGetLines(frame);
        CTLineRef line = CFArrayGetValueAtIndex(lines, 1);
        CFRange range = CTLineGetStringRange(line);
        
        
        suggestSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, range, NULL, constraints, NULL);
        CFRelease(path);
        CFRelease(frame);
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rect = {self.bounds.origin, suggestSize};
    NSLog(@"%@", NSStringFromCGRect(rect));
    CGPathAddRect(path, NULL, rect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    
    
    // transform
    
    
    CGRect backgroundRect = rect;
    //    backgroundRect.origin.x += 20;
    //    backgroundRect.size.width -= 20;
    CGContextDrawImage(context, backgroundRect, _backgroundImage.CGImage);
    
    CTFrameDraw(frame, context);
    
    // calculate
    NSArray *lines = (NSArray *)CTFrameGetLines(frame);
    CGPoint lineOrigins[lines.count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    for (int i = 0; i < lines.count; ++i) {
        CTLineRef line = (__bridge CTLineRef)lines[i];
        
        for (id obj in (NSArray *)CTLineGetGlyphRuns(line)) {
            CTRunRef run = (__bridge CTRunRef)obj;
            NSDictionary *runAtt = (NSDictionary *)CTRunGetAttributes(run);
            // if not image continue
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAtt valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) continue;
            UIImage *image = runAtt[SMTextAttachmentAttributeName];
            if (!image) continue;
            
            // calculate bounds
            CGFloat ascent, descent;
            CGRect runBounds;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL) - margin;
            runBounds.size.height = ascent + descent;
            
            CGFloat offsetX = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + offsetX + margin * 0.5;
            runBounds.origin.y = lineOrigins[i].y -  descent;
            
            CGPathRef pathRef = CTFrameGetPath(frame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            CGRect imageBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            CGContextDrawImage(context, imageBounds, image.CGImage);
        }
        
    }
    
    CFRelease(framesetter);
    CFRelease(path);
    CFRelease(frame);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.contents = (__bridge id)(image.CGImage);
}

@end

@implementation NSMutableAttributedString (SMDanmakuText)

//+ (NSMutableAttributedString *)backgroupImageStringWithImage:(UIImage *)image {
//
//}

+ (NSMutableAttributedString *)attachmentStringWithImage:(UIImage *)image size:(CGSize)size font:(UIFont *)font {
    
    NSMutableAttributedString *attrs = [[NSMutableAttributedString alloc] initWithString:SMTextAttachmentToken];
    
    [attrs setImageAttachment:image range:NSMakeRange(0, attrs.length)];
    
    CGFloat fontHeight = font.ascender - font.descender;
    CGFloat offsetY = font.ascender - fontHeight * 0.5;
    
    CGFloat ascent = size.height * 0.5 + offsetY;
    CGFloat descent = size.height - ascent;
    CGFloat width = size.width + margin;
    
    SMTextRunDelegate *delegate = [[SMTextRunDelegate alloc] init];
    delegate.width = width;
    delegate.ascent = ascent;
    delegate.descent = descent;
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    
    [attrs setRunDelegate:delegateRef range:NSMakeRange(0, attrs.length)];
    if (delegateRef) CFRelease(delegateRef);
    
    return attrs;
    
}

#pragma mark - Attribute
- (void)setFont:(UIFont *)font range:(NSRange)range {
    [self setAttribute:NSFontAttributeName value:font range:range];
}

- (void)setTextColor:(UIColor *)textColor range:(NSRange)range {
    [self setAttribute:NSForegroundColorAttributeName value:textColor range:range];
}

- (void)setRunDelegate:(CTRunDelegateRef)runDelegate range:(NSRange)range {
    [self setAttribute:(id)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
}

- (void)setImageAttachment:(UIImage *)image range:(NSRange)range {
    [self setAttribute:SMTextAttachmentAttributeName value:image range:range];
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

@end

@implementation SMTextRunDelegate
static void DeallocCallback(void *ref) {
    SMTextRunDelegate *self = (__bridge_transfer SMTextRunDelegate *)(ref);
    self = nil;
}

static CGFloat GetAscentCallback(void *ref) {
    SMTextRunDelegate *self = (__bridge SMTextRunDelegate *)(ref);
    return self.ascent;
}

static CGFloat GetDecentCallback(void *ref) {
    SMTextRunDelegate *self = (__bridge SMTextRunDelegate *)(ref);
    return self.descent;
}

static CGFloat GetWidthCallback(void *ref) {
    SMTextRunDelegate *self = (__bridge SMTextRunDelegate *)(ref);
    return self.width;
}

- (CTRunDelegateRef)CTRunDelegate {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks,0,sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = GetAscentCallback;
    callbacks.getDescent = GetDecentCallback;
    callbacks.getWidth = GetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)([self copy]));
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeFloat:_ascent forKey:@"ascent"];
    [encoder encodeFloat:_descent forKey:@"descent"];
    [encoder encodeFloat:_width forKey:@"width"];
    [encoder encodeObject:_userInfo forKey:@"userInfo"];
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    _ascent = [decoder decodeFloatForKey:@"ascent"];
    _descent = [decoder decodeFloatForKey:@"descent"];
    _width = [decoder decodeFloatForKey:@"width"];
    _userInfo = [decoder decodeObjectForKey:@"userInfo"];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    typeof(self) delegate = [self.class new];
    delegate.ascent = self.ascent;
    delegate.descent = self.descent;
    delegate.width = self.width;
    delegate.userInfo = self.userInfo;
    
    return delegate;
}
@end
