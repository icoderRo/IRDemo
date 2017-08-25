//
//  SMICellVideoFullViewController.h
//  smifun
//
//  Created by simon on 17/4/8.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SMICellVideoFullView : UIView
@end

@class SMICellVideoFullViewController;
@protocol SMICellVideoFullViewControllerDelegate <NSObject>

- (void)fullViewControllerLayoutIfNeed:(SMICellVideoFullViewController *)fullViewController;

@end

@interface SMICellVideoFullViewController : UIViewController
@property (nonatomic, weak) id<SMICellVideoFullViewControllerDelegate> delegate;
@end
