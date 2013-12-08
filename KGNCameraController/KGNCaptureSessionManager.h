//
//  KGNCaptureSessionManager.h
//  KGNCameraController
//
//  Created by David Keegan on 12/5/13.
//  Copyright (c) 2013 David Keegan. All rights reserved.
//

@import CoreMedia;
@import AVFoundation;

@interface KGNCaptureSessionManager : NSObject

@property (getter=isCapturingStillImage, readonly) BOOL capturingStillImage;
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic, readonly) AVCaptureSession *captureSession;
@property (nonatomic) AVCaptureDevicePosition cameraDirection;
@property (nonatomic) AVCaptureFlashMode flashMode;

- (BOOL)canTakePhoto;
- (BOOL)isCapturingStillImage;
- (BOOL)isCaptureSessionRunning;
- (void)captureStillImageWithCallback:(void(^)(UIImage *image))callback;

@end
