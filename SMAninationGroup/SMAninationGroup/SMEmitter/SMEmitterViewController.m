//
//  SMEmitterViewController.m
//  SMAninationGroup
//
//  Created by simon on 16/12/20.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "SMEmitterViewController.h"
#import "SMEmitterView.h"

@interface SMEmitterViewController ()
@property (nonatomic, weak) SMEmitterView *emitterView;
@end

@implementation SMEmitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SMEmitterView *emitterView = [[SMEmitterView alloc] init];
    emitterView.frame = CGRectMake(50, 120, 300, 400);
    emitterView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    emitterView.size = CGSizeMake(36, 36);
    emitterView.positionType = SMEmitterPositionRight;
    [self.view addSubview:emitterView];
    
    _emitterView = emitterView;
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.frame = CGRectMake(50, 550, 50, 50);
        [btn addTarget:self action:@selector(fire) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"star" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.frame = CGRectMake(120, 550, 50, 50);
        [btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"stop" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor redColor]];
        btn.frame = CGRectMake(190, 550, 50, 50);
        [btn addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"pause" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    {
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor blueColor]];
        btn.frame = CGRectMake(260, 550, 70, 50);
        [btn addTarget:self action:@selector(resume) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"resume" forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:UIApplicationDidEnterBackgroundNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resume) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)fire {
    [self.emitterView fireWithEmitterCount:50];
}


- (void)dealloc {
    [self stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stop {
    [self.emitterView stop];
}

- (void)pause {
    [self.emitterView pause];
}

- (void)resume {
    [self.emitterView resume];
}


@end
