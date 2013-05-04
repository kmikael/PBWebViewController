//
//  KMAppDelegate.m
//  Example
//
//  Created by Mikael Konutgan on 03/05/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMAppDelegate.h"
#import "KMMasterViewController.h"
#import "KMWebViewController.h"

@implementation KMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    KMMasterViewController *masterViewController = [[KMMasterViewController alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        self.window.rootViewController = self.navigationController;
    } else {
        UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
        KMWebViewController *webViewController = [[KMWebViewController alloc] init];
        UINavigationController *webNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    	masterViewController.webViewController = webViewController;
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.delegate = webViewController;
        self.splitViewController.viewControllers = @[masterNavigationController, webNavigationController];
        self.window.rootViewController = self.splitViewController;
    }
    [self.window makeKeyAndVisible];
    return YES;
}

@end
