//
//  SMAVPlayerViewController.m
//  SMAninationGroup
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "SMAVPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface SMAVPlayerViewController ()
@property (nonatomic, strong) AVAudioSession *session;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController *playerController;
@end

@implementation SMAVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAVPlayerViewController];
    
    [self setupCustomerPlayer];
}

- (void)setupCustomerPlayer {
    
    
    
}

/// 系统
- (void)setupAVPlayerViewController {
    _session = [AVAudioSession sharedInstance];
    [_session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    _player = [AVPlayer playerWithURL:[NSURL URLWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"]];
    _playerController = [[AVPlayerViewController alloc] init];
    _playerController.player = _player;
    _playerController.videoGravity = AVLayerVideoGravityResizeAspect;
    _playerController.allowsPictureInPicturePlayback = true;
    _playerController.showsPlaybackControls = true;
    
    [self addChildViewController:_playerController];
    _playerController.view.translatesAutoresizingMaskIntoConstraints = true;
    _playerController.view.frame = CGRectMake(0, 0, 320, 300);
    [self.view addSubview:_playerController.view];
    [_playerController.player play]; 
}
@end
