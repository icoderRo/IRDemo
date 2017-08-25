//
//  SMICellVideoView.h
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMICellVideoView : UIView
+ (instancetype)videoView;
@property (nonatomic, weak) UIViewController *contrainerViewController;
@property (nonatomic, weak) UIView *landscapeSuperView;
@property (nonatomic, copy) NSString *urlStr;
- (void)remove;
@end
