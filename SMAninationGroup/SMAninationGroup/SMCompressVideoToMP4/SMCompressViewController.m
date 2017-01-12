//
//  SMCompressViewController.m
//  SMAninationGroup
//
//  Created by simon on 17/1/12.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "SMCompressViewController.h"
#import <AVFoundation/AVFoundation.h>


typedef NS_ENUM(NSUInteger, viedoQuality) {
    viedoQualityLow,
    viedoQualityMedium,
    viedoQualityHigh,
};

@interface SMCompressViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation SMCompressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;
}


- (void)compressVideo:(NSURL *)inputURL Quality:(viedoQuality)quality success:(void (^)(NSURL *))success failure:(void (^)(NSString *))failure {
    
    NSString *presetName = nil;
    switch (quality) {
        case viedoQualityLow:
            presetName = AVAssetExportPresetLowQuality;
            break;
        case viedoQualityMedium:
            presetName = AVAssetExportPresetMediumQuality;
            break;
        case viedoQualityHigh:
            presetName = AVAssetExportPresetHighestQuality;
            break;
        default:
            break;
    }
    
    NSString *tempFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"compressVideo.mp4"] ;
    
    NSURL *savePathURL = [NSURL fileURLWithPath:tempFilePath];
    AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:inputURL options:kNilOptions];
    AVAssetExportSession *assetExport = [AVAssetExportSession exportSessionWithAsset:sourceAsset presetName:presetName];
    assetExport.outputFileType = AVFileTypeMPEG4;
    assetExport.outputURL = savePathURL;
    if (![[NSFileManager defaultManager] fileExistsAtPath:tempFilePath]) {
        return;
    }
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (assetExport.status) {
                case AVAssetExportSessionStatusCompleted:
                    if (success) {
                        success(savePathURL);
                    }
                    
                    break;
                    
                case AVAssetExportSessionStatusFailed:
                case AVAssetExportSessionStatusCancelled:
                case AVAssetExportSessionStatusUnknown:
                    if (failure) {
                        failure(@"压缩失败");
                    }
                    
                    break;
                    
                default:
                    break;
            }
        });
    }];
    
    
    
    
}

@end
