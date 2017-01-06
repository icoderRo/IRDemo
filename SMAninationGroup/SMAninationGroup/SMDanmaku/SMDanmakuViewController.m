//
//  SMBarrageViewController.m
//  SMAninationGroup
//
//  Created by simon on 16/12/23.<https://github.com/icoderRo/SMAnimation>

//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMDanmakuViewController.h"
#import "SMDanmakuView.h"
#define SMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define SMRandColor SMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
#define path(resurce, type, component) [[[NSBundle mainBundle] pathForResource:resurce ofType:type] stringByAppendingPathComponent:component]

@interface SMDanmakuViewController ()
@property (nonatomic, weak) SMDanmakuView *danmakuView;
@end

@implementation SMDanmakuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMDanmakuView *View = [[SMDanmakuView alloc] initWithFrame:CGRectMake(10, 74, kScreenW - 20, 400)];
    View.layer.cornerRadius = 5;
    View.layer.masksToBounds = YES;
    View.backgroundImage = [UIImage imageNamed:@"camera_blur_0"];
    View.danmakuBackgroundImage = [UIImage imageWithContentsOfFile:path(@"SMDanmaku", @"bundle", @"landscape_liuguang_blue")];
    [self.view addSubview:View];
    _danmakuView = View;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenW * 0.3, 500, 100, 70)];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(fire:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"fire" forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

- (void)fire:(UIButton *)btn {
    UIFont *font = [UIFont systemFontOfSize:17];
    UIImage *img = [UIImage imageNamed:@"fa-link"];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"弹幕图文测试"];
    NSMutableAttributedString *attachmentStr = [NSMutableAttributedString attachmentStringWithImage:img size:CGSizeMake(30, 30) font:font];
    

    NSMutableAttributedString *sendStr = [[NSMutableAttributedString alloc] init];
    
    [sendStr appendAttributedString:attachmentStr];
    [sendStr appendAttributedString:text];
    
    [sendStr setFont:[UIFont systemFontOfSize:15] range:NSMakeRange(0, sendStr.length)];
    [sendStr setTextColor:[UIColor blueColor] range:NSMakeRange(0, sendStr.length)];
    
    NSUInteger location = sendStr.length;
    
    [sendStr appendAttributedString:attachmentStr];
    [sendStr appendAttributedString:text];
    
    [sendStr setFont:font range:NSMakeRange(0, sendStr.length)];
    [sendStr setTextColor:[UIColor whiteColor] range:NSMakeRange(location, sendStr.length - location)];
    
    [sendStr appendAttributedString:attachmentStr];
    [sendStr appendAttributedString:text];
    [sendStr appendAttributedString:attachmentStr];
    [sendStr appendAttributedString:text];
    [self.danmakuView fireWithAttributedText:sendStr];
}
@end
