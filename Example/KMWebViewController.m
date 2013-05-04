//
//  KMWebViewController.m
//  Example
//
//  Created by Mikael Konutgan on 03/05/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMWebViewController.h"

@interface KMWebViewController ()

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation KMWebViewController

- (void)load
{
    [super load];
    if (self.masterPopoverController.isPopoverVisible) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Bookmarks", @"Bookmarks");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
