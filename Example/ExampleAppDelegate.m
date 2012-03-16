//
//  ExampleAppDelegate.m
//  DSGridView
//
//  Created by J. Bradford Dillon on 3/15/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import "ExampleAppDelegate.h"

#import "ExampleViewController.h"

@implementation ExampleAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.viewController = [[ExampleViewController alloc] init];

	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
