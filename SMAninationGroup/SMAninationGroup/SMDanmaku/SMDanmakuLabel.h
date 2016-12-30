//
//  SMDanmakuLabel.h
//  SMAninationGroup
//
//  Created by simon on 16/12/27.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDanmakuLabel : UIView


@property (nonatomic, copy) NSMutableAttributedString *attributedText;

@end

@interface NSMutableAttributedString (SMDanmakuText)

+ (NSMutableAttributedString *)attachmentStringWithImage:(UIImage *)image size:(CGSize)size font:(UIFont *)font;

@end
