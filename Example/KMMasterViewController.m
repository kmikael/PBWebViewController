//
//  KMMasterViewController.m
//  Example
//
//  Created by Mikael Konutgan on 03/05/2013.
//  Copyright (c) 2013 Mikael Konutgan. All rights reserved.
//

#import "KMMasterViewController.h"
#import "PBWebViewController.h"
#import "PBSafariActivity.h"

@interface KMMasterViewController ()

@property (strong, nonatomic) NSArray *bookmarks;

@end

@implementation KMMasterViewController

- (NSArray *)bookmarks
{
    if (!_bookmarks) {
        _bookmarks = @[
            @"http://www.apple.com",
            @"http://daringfireball.net",
            @"http://www.macstories.net",
            @"http://www.macdrifter.com",
            @"http://brettterpstra.com",
            @"http://www.pinbrowser.co"
        ];
    }
    return _bookmarks;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Bookmarks", @"Bookmarks");
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.webViewController clear];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bookmarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    cell.textLabel.text = self.bookmarks[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bookmark = self.bookmarks[indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (!self.webViewController) {
            self.webViewController = [[PBWebViewController alloc] init];
        }
    }
    
    PBSafariActivity *activity = [[PBSafariActivity alloc] init];
    self.webViewController.URL = [NSURL URLWithString:bookmark];
    self.webViewController.applicationActivities = @[activity];
    self.webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    } else {
        [self.webViewController load];
    }
}

@end
