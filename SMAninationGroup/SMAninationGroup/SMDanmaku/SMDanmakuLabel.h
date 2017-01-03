//
//  SMDanmakuLabel.h
//  SMAninationGroup
//
//  Created by simon on 16/12/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface SMDanmakuLabel : UIView

@property (nonatomic, copy) NSMutableAttributedString *attributedText;

@end

@interface NSMutableAttributedString (SMDanmakuText)

+ (NSMutableAttributedString *)attachmentStringWithImage:(UIImage *)image size:(CGSize)size font:(UIFont *)font;

@end


NS_ASSUME_NONNULL_BEGIN
/// Wrapper for CTRunDelegateRef.
@interface SMTextRunDelegate : NSObject<NSCopying, NSCoding>
@property (nullable,nonatomic,assign) CTRunDelegateRef CTRunDelegate;
@property (nonatomic,assign) CGFloat ascent;
@property (nonatomic,assign) CGFloat descent;
@property (nonatomic,assign) CGFloat width;
@property (nullable,nonatomic,strong) NSDictionary *userInfo;
@end
NS_ASSUME_NONNULL_END
