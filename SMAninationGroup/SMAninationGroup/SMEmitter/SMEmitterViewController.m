//
//  SMEmitterViewController.m
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterViewController.h"
#import "SMEmitterView.h"

@interface SMEmitterViewController ()<SMEmitterViewDelegate>
@property (nonatomic, weak) SMEmitterView *emitterView;
@property (nonatomic, weak) SMEmitterView *emitterView1;
@end

@implementation SMEmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        SMEmitterView *emitterView = [[SMEmitterView alloc] init];
        emitterView.frame = CGRectMake(10, 120, 200, 400);
        emitterView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        emitterView.emitterSize = CGSizeMake(36, 36);
        emitterView.positionType = SMEmitterPositionLeft;
        emitterView.delegate = self;
        [self.view addSubview:emitterView];
        
        _emitterView = emitterView;
        
    }
    
    {
        SMEmitterView *emitterView = [[SMEmitterView alloc] init];
        emitterView.frame = CGRectMake(210, 120, 200, 400);
        emitterView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        emitterView.positionType = SMEmitterPositionRight;
        [self.view addSubview:emitterView];
        _emitterView1 = emitterView;
        
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.frame = CGRectMake(30, 550, 70, 50);
        [btn addTarget:self action:@selector(fire) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"star" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.frame = CGRectMake(120, 550, 70, 50);
        [btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"stop" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.frame = CGRectMake(210, 550, 70, 50);
        [btn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"pause" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.frame = CGRectMake(300, 550, 70, 50);
        [btn addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"resume" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)fire {
    [self.emitterView fireWithEmitterCount:100];
    [self.emitterView1 fireWithImageNames:@[@"Sparkle1", @"Sparkle2", @"Sparkle3"] emitterCount:10];
}

- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stop {
    [self.emitterView stop];
    [self.emitterView1 stop];
}

- (void)pause {
    [self.emitterView pause];
    [self.emitterView1 pause];
}

- (void)resume {
    [self.emitterView resume];
    [self.emitterView1 resume];
}

#pragma mark - 
- (void)emitterView:(SMEmitterView *)emitterView didAddEmitterCount:(NSUInteger)emitterCount {
    
    NSLog(@"%zd", emitterCount);
    
    // socket...
}
@end
