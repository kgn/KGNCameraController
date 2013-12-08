//
//  KGNCameraController.h
//  KGNCameraController
//
//  Created by David Keegan on 12/5/13.
//  Copyright (c) 2013 David Keegan. All rights reserved.
//

@class KGNCaptureSessionManager;

@interface KGNCameraController : UIViewController
@property (strong, nonatomic, readonly) KGNCaptureSessionManager *captureSessionManager;
@end
