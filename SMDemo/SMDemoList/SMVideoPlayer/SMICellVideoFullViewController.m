//
//  SMICellVideoFullViewController.m
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMICellVideoFullViewController.h"
#import "SMICellVideoView.h"

@implementation SMICellVideoFullView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizesSubviews = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor blackColor];
    }
    
    return self;
}

@end

@implementation SMICellVideoFullViewController

- (void)loadView {
    self.view = [[SMICellVideoFullView alloc] init];
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation {
    UIDevice *device = [UIDevice currentDevice] ;
    
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationPortrait:
            if ([self.delegate respondsToSelector:@selector(fullViewControllerLayoutIfNeed:)]) {
                [self.delegate fullViewControllerLayoutIfNeed:self];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil ];
    
    [[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
}

@end
