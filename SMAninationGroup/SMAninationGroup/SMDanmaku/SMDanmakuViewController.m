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
    View.danmakuBackgroundColor = SMRandColor;
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
    UIFont *font = [UIFont systemFontOfSize:25];
    UIImage *img = [UIImage imageNamed:@"fa-link"];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:@"弹幕图文测试"];
    NSMutableAttributedString *attachmentStr = [NSMutableAttributedString attachmentStringWithImage:img size:CGSizeMake(30, 30) font:font];
    [text appendAttributedString:attachmentStr];
    
    [text setFont:[UIFont systemFontOfSize:20] range:NSMakeRange(0, text.length)];
    [text setTextColor:[UIColor redColor] range:NSMakeRange(0, text.length)];
    
    [self.danmakuView fireWithAttributedText:text];
}


@end
