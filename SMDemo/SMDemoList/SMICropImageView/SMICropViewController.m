//
//  SMICropViewController.m
//  smifun
//
//  Created by simon on 17/1/17.
//  Copyright © 2017年 SMI HOLDING GROUP. All rights reserved.
//

#import "SMICropViewController.h"
#import "SMICropMaskerView.h"
#import "SMICropBottomView.h"

@interface SMICropViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *cropBoxView;
@property (nonatomic, strong) SMICropMaskerView *maskerView;
@property (nonatomic, strong) SMICropBottomView *bottomView;

@end

@implementation SMICropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    [self setupScrollerView];
    [self setupMaskerView];
    [self setupCropBoxView];
    [self setupImageView];
    
    [self setupGesAndDraw];
    [self setupBottomView];
}

- (void)setupScrollerView {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.delegate = self;
    _scrollView.frame = self.view.bounds;
    [self.view addSubview:_scrollView];
}

- (void)setupCropBoxView {
    _cropBoxView = [[UIImageView alloc]init];
    UIImage *image = [UIImage imageNamed:@"CropBox"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    _cropBoxView.image = image;
    _cropBoxView.backgroundColor = [UIColor clearColor];
    if (self.cropType == SMICropViewTypeSquare) {
        _cropBoxView.size = CGSizeMake(SMIValue(300), SMIValue(300));
    } else {
        _cropBoxView.size = CGSizeMake(SMIValue(343), SMIValue(210));
    }
    _cropBoxView.center = self.view.center;
    [self.view addSubview:_cropBoxView];
}

- (void)setupMaskerView {
    
    _maskerView = [[SMICropMaskerView alloc] init];
    _maskerView.backgroundColor = [UIColor clearColor];
    _maskerView.maskerColor = HEXCOLORAL(51, 0.3);
    _maskerView.userInteractionEnabled = NO;
    _maskerView.frame = self.view.bounds;
    [self.view addSubview:_maskerView];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.userInteractionEnabled = YES;
    _imageView.image = self.sourceImage;
    
    _imageView.frame = CGRectMake(0, 0, self.sourceImage.size.width, self.sourceImage.size.height);
    CGSize imageSize = self.sourceImage.size;
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = imageSize;
    [self.scrollView addSubview:self.imageView];
    
    CGFloat scale = 0.0f;
    CGSize cropBoxSize = self.cropBoxView.bounds.size;
    scale = MAX(self.view.width/imageSize.width, self.view.height/imageSize.height);
    CGSize scaledSize = (CGSize){floorf(imageSize.width * scale), floorf(imageSize.height * scale)};
    CGFloat minimumZoomScale = MAX(cropBoxSize.width/imageSize.width, cropBoxSize.height/imageSize.height);

    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.maximumZoomScale = 3.0f;
    
    self.scrollView.zoomScale = scale;
    self.scrollView.contentSize = scaledSize;
    
    CGRect cropBoxFrame = self.cropBoxView.frame;
    
    if (cropBoxFrame.size.width < scaledSize.width - FLT_EPSILON || cropBoxFrame.size.height < scaledSize.height - FLT_EPSILON) {
        CGPoint offset = CGPointZero;
        offset.x = -floorf((CGRectGetWidth(self.scrollView.frame) - scaledSize.width) * 0.5f);
        offset.y = -floorf((CGRectGetHeight(self.scrollView.frame) - scaledSize.height) * 0.5f);
        self.scrollView.contentOffset = offset;
    }
    
    self.scrollView.contentInset = (UIEdgeInsets){CGRectGetMinY(cropBoxFrame),
        CGRectGetMinX(cropBoxFrame),
        CGRectGetMaxY(self.view.bounds) - CGRectGetMaxY(cropBoxFrame),
        CGRectGetMaxX(self.view.bounds) - CGRectGetMaxX(cropBoxFrame)};
}

- (void)setupGesAndDraw {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.maskerView.cropBoxPath = [UIBezierPath bezierPathWithRect:self.cropBoxView.frame];
    [self.maskerView setNeedsDisplay];
}

- (void)setupBottomView {
    
    CGFloat height = SMIValue(49);
    
    _bottomView = [[SMICropBottomView alloc] initWithFrame:CGRectMake(0, self.view.height - height, self.view.width, height)];
    _bottomView.backgroundColor = HEXCOLORAL(71, 0.3);
    [self.view addSubview:_bottomView];
    
    [_bottomView.cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
     [_bottomView.sureBtn addTarget:self action:@selector(didClickSureBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickCancelBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickSureBtn {
    
    if (self.imageHandle) {
        self.imageHandle([self cropBoxImage]);
    }
}

#pragma mark - action
- (CGRect)imageCropBoxFrame {
    CGSize imageSize = self.imageView.image.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGRect cropBoxFrame = self.cropBoxView.frame;
    CGPoint contentOffset = self.scrollView.contentOffset;
    UIEdgeInsets edgeInsets = self.scrollView.contentInset;
    
    CGRect frame = CGRectZero;
    frame.origin.x = floorf((contentOffset.x + edgeInsets.left) * (imageSize.width / contentSize.width));
    frame.origin.x = MAX(0, frame.origin.x);
    frame.origin.y = floorf((contentOffset.y + edgeInsets.top) * (imageSize.height / contentSize.height));
    frame.origin.y = MAX(0, frame.origin.y);
    frame.size.width = ceilf(cropBoxFrame.size.width * (imageSize.width / contentSize.width));
    frame.size.width = MIN(imageSize.width, frame.size.width);
    frame.size.height = ceilf(cropBoxFrame.size.height * (imageSize.height / contentSize.height));
    frame.size.height = MIN(imageSize.height, frame.size.height);
    
    return frame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (UIImage *)cropBoxImage {
    return [self.imageView.image croppedImageWithFrame:[self imageCropBoxFrame]];
}

@end
