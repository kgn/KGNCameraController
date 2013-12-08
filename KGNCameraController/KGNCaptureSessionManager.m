//
//  KGNCaptureSessionManager.m
//  KGNCameraController
//
//  Created by David Keegan on 12/5/13.
//  Copyright (c) 2013 David Keegan. All rights reserved.
//

#import "KGNCaptureSessionManager.h"

@interface KGNCaptureSessionManager()
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic, readwrite) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic, readwrite) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDeviceInput *frontCameraInput;
@property (strong, nonatomic) AVCaptureDeviceInput *backCameraInput;
@end

@implementation KGNCaptureSessionManager

- (void)dealloc{
	[self.captureSession stopRunning];
}

- (id)init{
	if(!(self = [super init])){
        return nil;
	}

    self.captureSession = [AVCaptureSession new];

    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    [self addVideoInput];
    [self addStillImageInput];

	return self;
}

- (void)setFlashMode:(AVCaptureFlashMode)flashMode{
    [self willChangeValueForKey:NSStringFromSelector(@selector(flashMode))];

    _flashMode = flashMode;

    if([self.frontCameraInput.device isFlashModeSupported:self.flashMode]){
        [self.frontCameraInput.device lockForConfiguration:nil];
        self.frontCameraInput.device.flashMode = self.flashMode;
        [self.frontCameraInput.device unlockForConfiguration];
    }

    if([self.backCameraInput.device isFlashModeSupported:self.flashMode]){
        [self.backCameraInput.device lockForConfiguration:nil];
        self.backCameraInput.device.flashMode = self.flashMode;
        [self.backCameraInput.device unlockForConfiguration];
    }

    [self didChangeValueForKey:NSStringFromSelector(@selector(flashMode))];
}

- (void)setCameraDirection:(AVCaptureDevicePosition)cameraDirection{
    [self willChangeValueForKey:NSStringFromSelector(@selector(cameraDirection))];

    _cameraDirection = cameraDirection;

    if(self.cameraDirection == AVCaptureDevicePositionUnspecified){
        [self.captureSession removeInput:self.frontCameraInput];
        [self.captureSession removeInput:self.backCameraInput];
    }else if(self.cameraDirection == AVCaptureDevicePositionFront && self.frontCameraInput){
        [self.captureSession removeInput:self.backCameraInput];
        if([self.captureSession canAddInput:self.frontCameraInput]){
            [self.captureSession addInput:self.frontCameraInput];
        }
    }else if(self.cameraDirection == AVCaptureDevicePositionBack && self.backCameraInput){
        [self.captureSession removeInput:self.frontCameraInput];
        if([self.captureSession canAddInput:self.backCameraInput]){
            [self.captureSession addInput:self.backCameraInput];
        }
    }

    [self didChangeValueForKey:NSStringFromSelector(@selector(cameraDirection))];
}

- (void)addStillImageInput{
    self.stillImageOutput = [AVCaptureStillImageOutput new];
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey: AVVideoCodecJPEG}];
    if([self.captureSession canAddOutput:self.stillImageOutput]){
        [self.captureSession addOutput:self.stillImageOutput];
    }
}

- (void)addVideoInput{
    __block AVCaptureDevice *frontCamera;
    __block AVCaptureDevice *backCamera;
    [[AVCaptureDevice devices] enumerateObjectsUsingBlock:^(AVCaptureDevice *device, NSUInteger idx, BOOL *stop){
        if(![device hasMediaType:AVMediaTypeVideo]){
            return;
        }

        switch(device.position){
            case AVCaptureDevicePositionUnspecified:
                return;
            case AVCaptureDevicePositionFront:
                frontCamera = device;
                break;
            case AVCaptureDevicePositionBack:
                backCamera = device;
                break;
        }
    }];

    NSError *frontCameraError = nil;
    self.frontCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&frontCameraError];
    if(frontCameraError){
        self.frontCameraInput = nil;
    }

    NSError *backCameraError = nil;
    self.backCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:&backCameraError];
    if(backCameraError){
        self.backCameraInput = nil;
    }
}

- (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections{
	for(AVCaptureConnection *connection in connections){
		for(AVCaptureInputPort *port in connection.inputPorts){
			if([[port mediaType] isEqual:mediaType]){
				return connection;
			}
		}
	}
	return nil;
}

- (BOOL)canTakePhoto{
    return (!!self.frontCameraInput || !!self.backCameraInput);
}

- (BOOL)isCaptureSessionRunning{
    return self.captureSession.isRunning;
}

- (BOOL)isCapturingStillImage{
    return self.stillImageOutput.isCapturingStillImage;
}

- (void)captureStillImageWithCallback:(void(^)(UIImage *image))callback{
    AVCaptureConnection *stillImageConnection =
    [self connectionWithMediaType:AVMediaTypeVideo fromConnections:self.stillImageOutput.connections];

    [self.stillImageOutput
     captureStillImageAsynchronouslyFromConnection:stillImageConnection
     completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
         UIImage *image = [UIImage imageWithData:imageData];
         if(callback){
             callback(image);
         }
     }];
}

@end
