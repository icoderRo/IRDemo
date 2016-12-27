//
//  SMBarrageViewController.m
//  SMAninationGroup
//
//  Created by simon on 16/12/23.<https://github.com/icoderRo/SMAnimationDemo>

//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMDanmakuViewController.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height
#define path(resurce, type, component) [[[NSBundle mainBundle] pathForResource:resurce ofType:type] stringByAppendingPathComponent:component]
@interface SMDanmakuViewController ()

@end

@implementation SMDanmakuViewController
- (void)loadView {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_blur_0"]];
    imageView.userInteractionEnabled = YES;
    self.view = imageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];

}


@end
