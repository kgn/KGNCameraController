//
//  KGNAppDelegate.m
//  Example
//
//  Created by David Keegan on 12/5/13.
//  Copyright (c) 2013 David Keegan. All rights reserved.
//

#import "KGNAppDelegate.h"
#import "KGNCameraController.h"

@implementation KGNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [KGNCameraController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
