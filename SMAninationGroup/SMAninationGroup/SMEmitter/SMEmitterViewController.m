//
//  SMEmitterViewController.m
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterViewController.h"
#import "SMEmitterView.h"
#import "SMEmitterButton.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define KScreenH [UIScreen mainScreen].bounds.size.height

#define path(resurce, type, component) [[[NSBundle mainBundle] pathForResource:resurce ofType:type] stringByAppendingPathComponent:component]

@interface SMEmitterViewController ()<SMEmitterViewDelegate>
@property (nonatomic, weak) SMEmitterView *emitterView;
@property (nonatomic, weak) SMEmitterView *emitterView1;
@property (nonatomic, weak) SMEmitterView *emitterView2;


@end

@implementation SMEmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = (kScreenW / 3);
    
    NSString *path = path(@"emitter", @"bundle", @"heart");
    NSString *path1 = path(@"emitter", @"bundle", @"heart_N");
    
    NSArray *sparkles = @[[UIImage imageWithContentsOfFile:path(@"emitter", @"bundle", @"Sparkle1")], [UIImage imageWithContentsOfFile:path(@"emitter", @"bundle", @"Sparkle3")]];
    
    {
        SMEmitterView *emitterView = [[SMEmitterView alloc] init];
        emitterView.frame = CGRectMake(10, 120, width, 400);
        emitterView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        emitterView.emitterSize = CGSizeMake(36, 36);
        emitterView.positionType = SMEmitterPositionLeft;
        emitterView.delegate = self;
        [self.view addSubview:emitterView];
        
        _emitterView = emitterView;
        
    }
    
    {
        SMEmitterView *emitterView = [[SMEmitterView alloc] init];
        emitterView.frame = CGRectMake(width + 10, 120, width, 400);
        emitterView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        emitterView.positionType = SMEmitterPositionRight;
        
        NSString *path = path(@"emitter", @"bundle", @"龙珠");
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:21];
        NSString *imageName = nil;
        UIImage *image = nil;
        for (int i = 0; i < 21; i++) {
            imageName = [NSString stringWithFormat:@"heart%zd",i];
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
            [images addObject:image];
        }
        
        emitterView.images = images.copy;
        [self.view addSubview:emitterView];
        _emitterView1 = emitterView;
        
    }
    
    {
        SMEmitterView *emitterView = [[SMEmitterView alloc] init];
        emitterView.frame = CGRectMake(2 * width + 10, 120, width, 400);
        emitterView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        emitterView.positionType = SMEmitterPositionCenter;
        
        NSString *path = path(@"emitter", @"bundle", @"虎牙");
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:9];
        NSString *imageName = nil;
        UIImage *image = nil;
        for (int i = 0; i < 9; i++) {
            imageName = [NSString stringWithFormat:@"icon_mobile_live_praise_%zd",i];
            image = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:imageName]];
            [images addObject:image];
        }
        
        emitterView.images = images.copy;
        [self.view addSubview:emitterView];
        _emitterView2 = emitterView;
        
    }
    
    {
        SMEmitterButton *btn = [[SMEmitterButton alloc] initWithEmitters:sparkles frame:CGRectMake(30, 550, 46, 46)];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fire) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"star" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        SMEmitterButton *btn = [[SMEmitterButton alloc] initWithEmitters:sparkles frame:CGRectMake(120, 550, 46, 46)];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"stop" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        SMEmitterButton *btn = [[SMEmitterButton alloc] initWithEmitters:sparkles frame:CGRectMake(210, 550, 46, 46)];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateNormal];

        [btn addTarget:self action:@selector(pause:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"pause" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        SMEmitterButton *btn = [[SMEmitterButton alloc] initWithEmitters:sparkles frame:CGRectMake(300, 550, 46, 46)];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithContentsOfFile:path1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(resume:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"resume" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)fire {
    [self.emitterView fireWithEmitterCount:100];
    [self.emitterView1 fireWithEmitterCount:100];
    [self.emitterView2 fireWithEmitterCount:100];
    
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stop {
    [self.emitterView stop];
    [self.emitterView1 stop];
    [self.emitterView2 stop];
}

- (void)pause:(UIButton *)btn {
    [self.emitterView pause];
    [self.emitterView1 pause];
    [self.emitterView2 pause];
    btn.selected = !btn.isSelected;
    
}

- (void)resume:(UIButton *)btn {
    [self.emitterView resume];
    [self.emitterView1 resume];
    [self.emitterView2 resume];
    btn.selected = !btn.isSelected;
    
}

#pragma mark -
- (void)emitterView:(SMEmitterView *)emitterView didAddEmitterCount:(NSUInteger)emitterCount {
    
    NSLog(@"%zd", emitterCount);
    
    // socket...
}
@end
