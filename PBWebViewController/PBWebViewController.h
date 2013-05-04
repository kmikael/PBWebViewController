//
//  PBWebViewController.h
//  Pinbrowser
//
//  Created by Mikael Konutgan on 11/02/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBWebViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSURL *URL;

@property (strong, nonatomic) NSArray *activityItems;
@property (strong, nonatomic) NSArray *applicationActivities;
@property (strong, nonatomic) NSArray *excludedActivityTypes;

- (void)load;

@end
