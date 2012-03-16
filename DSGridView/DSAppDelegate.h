//
//  DSAppDelegate.h
//  DSGridView
//
//  Created by J. Bradford Dillon on 3/15/12.
//  Copyright (c) 2012 Dreamsocket. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSViewController;

@interface DSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) DSViewController *viewController;

@end
