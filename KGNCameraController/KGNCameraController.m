//
//  KGNCameraController.m
//  KGNCameraController
//
//  Created by David Keegan on 12/5/13.
//  Copyright (c) 2013 David Keegan. All rights reserved.
//

#import "KGNCameraController.h"
#import "KGNCaptureSessionManager.h"

@interface KGNCameraController()
@property (strong, nonatomic, readwrite) KGNCaptureSessionManager *captureSessionManager;
@end

@implementation KGNCameraController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])){
        return nil;
    }

    self.captureSessionManager = [KGNCaptureSessionManager new];
	[self.view.layer addSublayer:self.captureSessionManager.previewLayer];
    self.captureSessionManager.cameraDirection = AVCaptureDevicePositionFront;
    self.captureSessionManager.flashMode = AVCaptureFlashModeAuto;

    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.captureSessionManager.captureSession startRunning];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.captureSessionManager.captureSession stopRunning];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];

	CGRect layerRect = self.view.layer.bounds;
	[self.captureSessionManager.previewLayer setBounds:layerRect];
	[self.captureSessionManager.previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))];
}

@end
