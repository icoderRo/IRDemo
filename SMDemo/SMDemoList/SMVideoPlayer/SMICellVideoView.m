//
//  SMICellVideoView.m
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMICellVideoView.h"
#import "SMICellVideoItemsView.h"
#import "SMICellVideoFullViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface SMICellVideoView ()<SMICellVideoItemsViewDelegate, SMICellVideoFullViewControllerDelegate>
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) NSTimer *progressTimer;

@property (nonatomic, strong) SMICellVideoFullViewController *fullVc;
@property (nonatomic, strong) SMICellVideoItemsView *itemsView;

@end

static NSString *playerStatus = @"status";

@implementation SMICellVideoView
+ (instancetype)videoView {
    static SMICellVideoView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[self alloc] init];
    });
    return view;
}


- (instancetype)init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showItemsView)]];
        self.backgroundColor = [UIColor blackColor];
        self.player = [[AVPlayer alloc] init];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:self.playerLayer];
        [self willHideItemsView];
        
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:playerStatus];
    }
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    if (!item) {return;}
    
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [item addObserver:self forKeyPath:playerStatus options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:playerStatus]) {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (AVPlayerItemStatusReadyToPlay == status) {
            [self removeProgressTimer];
            [self addProgressTimer];
            self.itemsView.totalTimeLabel.text = [self timeStringWithTime:CMTimeGetSeconds(self.player.currentItem.asset.duration)];
            [self.player play];
        } else {
            self.itemsView.totalTimeLabel.text = @"00:00";
            self.itemsView.currentTimeLabel.text = @"00:00";
            [self removeProgressTimer];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            if (self.player.currentItem) {
                [self.player.currentItem removeObserver:self forKeyPath:playerStatus];
            }
        }
    }
}

#pragma mark - orientation
- (void)portrait {
    
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIDeviceOrientationPortrait;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    [AppDelegate sharedAppDelegate].canRotate = NO;
    [self.fullVc dismissViewControllerAnimated:NO completion:^{
        [self.landscapeSuperView addSubview:self];
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.frame = self.landscapeSuperView.bounds;
        } completion:nil];
    }];
}

- (void)landscape {
    
    [AppDelegate sharedAppDelegate].canRotate = YES;
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = UIInterfaceOrientationLandscapeRight;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
    
    [self.contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
        [self.fullVc.view insertSubview:self atIndex:0];
        self.center = self.fullVc.view.center;
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.bounds = self.fullVc.view.bounds;
        } completion:nil];
    }];
}

#pragma mark - Action
- (void)playbackFinished:(NSNotification *)note {
    [self.player.currentItem seekToTime:kCMTimeZero];
    [self.player pause];
    [self.itemsView.playOrPauseBtn setSelected:YES];
    [self showItemsView];
}

- (void)addProgressTimer {
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo {
    self.itemsView.currentTimeLabel.text = [self timeStringWithTime:CMTimeGetSeconds(self.player.currentTime)];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.itemsView.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.asset.duration);
    }];
}

#pragma mark - SMICellVideoItemsViewDelegate
- (void)itemsView:(SMICellVideoItemsView *)itemsView didClickStartPlay:(BOOL)isStart {
    
    if (!isStart) {
        [self.player pause];
        [self.itemsView.playOrPauseBtn setSelected:YES];
        [self removeProgressTimer];
    } else {
        [self.player play];
        [self addProgressTimer];
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self willHideItemsView];
}

- (void)itemsView:(SMICellVideoItemsView *)itemsView didClickOrientationWithLandscape:(BOOL)isLandscape {
    
    if (isLandscape) {
        [self landscape];
    } else {
        [self portrait];
    }
}

- (void)itemsViewDidStartSlider:(SMICellVideoItemsView *)itemsView {
    [self.player pause];
    [self removeProgressTimer];
}

- (void)itemsView:(SMICellVideoItemsView *)itemsView didDragSliderWithValue:(float)value {
    self.itemsView.currentTimeLabel.text = [self timeStringWithTime:CMTimeGetSeconds(self.player.currentItem.duration) * self.itemsView.progressSlider.value];
}

- (void)itemsView:(SMICellVideoItemsView *)itemsView didSliderWithValue:(float)value {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.itemsView.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark - SMICellVideoFullViewControllerDelegate
- (void)fullViewControllerLayoutIfNeed:(SMICellVideoFullViewController *)fullViewController {
    self.frame = self.fullVc.view.bounds;
    [self layoutIfNeeded];
}

#pragma mark - TouchesBegan
- (void)showItemsView {
    [UIView animateWithDuration:1.0 animations:^{
        self.itemsView.alpha = 1;
    }];
}

- (void)willHideItemsView {
    [self performSelector:@selector(hideItemsView) withObject:self afterDelay:2.0];
}

- (void)hideItemsView {
    [UIView animateWithDuration:1.0 animations:^{
        self.itemsView.alpha = 0;
    }];
}
#pragma mark - Lazy
- (SMICellVideoItemsView *)itemsView {
    if (!_itemsView) {
        _itemsView = [[SMICellVideoItemsView alloc] init];
        _itemsView.delegate = self;
        [self addSubview:_itemsView];
    }
    return _itemsView;
}

- (SMICellVideoFullViewController *)fullVc {
    if (!_fullVc ) {
        _fullVc = [[SMICellVideoFullViewController alloc] init];
        _fullVc.delegate = self;
    }
    return _fullVc;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
    [self.itemsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (NSString *)timeStringWithTime:(Float64)currentTime {
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    return currentString;
}


- (void)remove {
    self.itemsView.playOrPauseBtn.selected = YES;
    [self.player pause];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:playerStatus];
    }
}

@end
