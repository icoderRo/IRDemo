//
//  SMDanmakuView.h
//  SMAninationGroup
//
//  Created by simon on 17/1/3.
//  Copyright © 2017年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN
@interface SMDanmakuView : UIView
@property (nullable, nonatomic, strong) UIImage *backgroundImage;
@property (nullable, nonatomic, strong) UIColor *danmakuBackgroundColor;
@property (nullable, nonatomic, strong) UIImage *danmakuBackgroundImage;

- (void)fireWithAttributedText:(NSMutableAttributedString *)attributedText;
@end

@interface SMDanmakuLayer : CALayer
@property (nonatomic, copy) NSMutableAttributedString *attributedText;
@property (nullable, nonatomic, strong) UIImage *backgroundImage;
@end

@interface NSMutableAttributedString (SMDanmakuText)
+ (NSMutableAttributedString *)attachmentStringWithImage:(UIImage *)image size:(CGSize)size font:(UIFont *)font;
- (void)setTextColor:(nullable UIColor *)textColor range:(NSRange)range;
- (void)setFont:(nullable UIFont *)font range:(NSRange)range;
@end

@interface SMTextRunDelegate : NSObject<NSCopying, NSCoding>
@property (nonatomic, assign) CTRunDelegateRef CTRunDelegate;
@property (nonatomic, assign) CGFloat ascent;
@property (nonatomic, assign) CGFloat descent;
@property (nonatomic, assign) CGFloat width;
@property (nullable, nonatomic, strong) NSDictionary *userInfo;
@end
NS_ASSUME_NONNULL_END
