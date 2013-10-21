//
//  PBWebViewController.m
//  Pinbrowser
//
//  Created by Mikael Konutgan on 11/02/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "PBWebViewController.h"

@interface PBWebViewController () <UIPopoverControllerDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) UIBarButtonItem *stopLoadingButton;
@property (strong, nonatomic) UIBarButtonItem *reloadButton;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;

@property (strong, nonatomic) UIPopoverController *activitiyPopoverController;

@end

@implementation PBWebViewController

- (void)load
{
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.webView loadRequest:request];

    if (self.navigationController.toolbarHidden) {
        [self.navigationController setToolbarHidden:NO animated:YES];
    }
}

- (void)clear
{
    [self.webView loadHTMLString:@"" baseURL:nil];
    self.title = @"";
}

#pragma mark - View controller lifecycle

- (void)loadView
{
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.view = self.webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupToolBarItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.delegate = self;
    if (self.URL) {
        [self load];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
    self.webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Helpers

- (UIImage *)leftTriangleImage
{
    static UIImage *image;

    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        CGSize size = CGSizeMake(14.0f, 16.0f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);

        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 8.0f)];
        [path addLineToPoint:CGPointMake(14.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(14.0f, 16.0f)];
        [path closePath];
        [path fill];

        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });

    return image;
}

- (UIImage *)rightTriangleImage
{

    static UIImage *rightTriangleImage;

    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        UIImage *leftTriangleImage = [self leftTriangleImage];

        CGSize size = leftTriangleImage.size;

        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGFloat x_mid = size.width / 2.0f;
        CGFloat y_mid = size.height / 2.0f;

        CGContextTranslateCTM(context, x_mid, y_mid);

        CGContextRotateCTM(context, M_PI);
        [leftTriangleImage drawAtPoint:CGPointMake((x_mid * -1), (y_mid * -1))];

        rightTriangleImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });

    return rightTriangleImage;


}

- (void)setupToolBarItems
{
    self.stopLoadingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                           target:self.webView
                                                                           action:@selector(stopLoading)];

    self.reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                      target:self.webView
                                                                      action:@selector(reload)];

    self.backButton = [[UIBarButtonItem alloc] initWithImage:[self leftTriangleImage]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self.webView
                                                      action:@selector(goBack)];

    self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[self rightTriangleImage]
                                                          style:UIBarButtonItemStylePlain
                                                         target:self.webView
                                                         action:@selector(goForward)];

    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;

    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                  target:self
                                                                                  action:@selector(action:)];

    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                           target:nil
                                                                           action:nil];

    UIBarButtonItem *space_ = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                            target:nil
                                                                            action:nil];
    space_.width = 60.0f;

    self.toolbarItems = @[self.stopLoadingButton, space, self.backButton, space_, self.forwardButton, space, actionButton];
}

- (void)toggleState
{
    self.backButton.enabled = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

    NSMutableArray *toolbarItems = [self.toolbarItems mutableCopy];
    if (self.webView.loading) {
        toolbarItems[0] = self.stopLoadingButton;
    } else {
        toolbarItems[0] = self.reloadButton;
    }
    self.toolbarItems = [toolbarItems copy];
}

- (void)finishLoad
{
    [self toggleState];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Button actions

- (void)action:(id)sender
{
    if (self.activitiyPopoverController.popoverVisible) {
        [self.activitiyPopoverController dismissPopoverAnimated:YES];
        return;
    }

    NSArray *activityItems;
    if (self.activityItems) {
        activityItems = [self.activityItems arrayByAddingObject:self.URL];
    } else {
        activityItems = @[self.URL];
    }

    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems
                                                                     applicationActivities:self.applicationActivities];
    if (self.excludedActivityTypes) {
        vc.excludedActivityTypes = self.excludedActivityTypes;
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:vc animated:YES completion:NULL];
    } else {
        if (!self.activitiyPopoverController) {
            self.activitiyPopoverController = [[UIPopoverController alloc] initWithContentViewController:vc];
        }
        self.activitiyPopoverController.delegate = self;
        [self.activitiyPopoverController presentPopoverFromBarButtonItem:[self.toolbarItems lastObject]
                                                permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self toggleState];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self finishLoad];
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.URL = self.webView.request.URL;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self finishLoad];
}

#pragma mark - Popover controller delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.activitiyPopoverController = nil;
}

@end
