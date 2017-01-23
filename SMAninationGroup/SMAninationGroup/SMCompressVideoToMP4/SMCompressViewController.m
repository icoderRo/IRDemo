//
//  SMCompressViewController.m
//  SMAninationGroup
//
//  Created by simon on 17/1/12.
//  Copyright © 2017年 simon. All rights reserved.
//

#import "SMCompressViewController.h"
#import <AVFoundation/AVFoundation.h>
/// 压缩为MP4
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
    
    return;
    
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;    NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];    ipc.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate = self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
    NSLog(@"原视频时间 %@",[NSString stringWithFormat:@"%f s", [self getVideoSecond:sourceURL]]);
    NSLog(@"原视频大小 %@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[sourceURL path]]]);
    
    
    [self compressVideo:sourceURL Quality:viedoQualityMedium success:^(NSURL *url) {
        NSLog(@"压缩后视频时间 %@",[NSString stringWithFormat:@"%f s", [self getVideoSecond:url]]);
        NSLog(@"压缩后视频大小 %@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[url path]]]);

    } failure:^(NSString *error) {
        NSLog(@"%@", error);
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize; // KB。
}


- (CGFloat) getVideoSecond:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
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
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *tempFilePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"compressVideo%@.mp4", [formater stringFromDate:[NSDate date]]]];
    
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
