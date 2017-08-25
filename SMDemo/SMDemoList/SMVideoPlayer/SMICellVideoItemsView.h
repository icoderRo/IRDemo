//
//  SMICellVideoItemsView.h
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SMICellVideoItemsView;
@protocol SMICellVideoItemsViewDelegate <NSObject>

- (void)itemsView:(SMICellVideoItemsView *)itemsView didClickStartPlay:(BOOL)isStart;

- (void)itemsView:(SMICellVideoItemsView *)itemsView didClickOrientationWithLandscape:(BOOL)isLandscape;

- (void)itemsViewDidStartSlider:(SMICellVideoItemsView *)itemsView;
- (void)itemsView:(SMICellVideoItemsView *)itemsView didDragSliderWithValue:(float)value;
- (void)itemsView:(SMICellVideoItemsView *)itemsView didSliderWithValue:(float)value;

@end
@interface SMICellVideoItemsView : UIView
@property (nonatomic, weak) id<SMICellVideoItemsViewDelegate> delegate;
@property (nonatomic, strong, readonly) UISlider *progressSlider;
@property (nonatomic, strong, readonly) UILabel *totalTimeLabel;
@property (nonatomic, strong, readonly) UILabel *currentTimeLabel;
@property (nonatomic, strong, readonly) UIButton *playOrPauseBtn;
@end
