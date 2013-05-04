# PBWebViewController

`PBWebViewController` is a light-weight, simple and extendible web browser component for iOS. It's just 2 source files, no images, around 200 lines of code and has been built with modern Cocoa development techniques.

![](http://f.cl.ly/items/2i0m0j0U3H240t0k0i38/PBWebViewController.png)

## Installation

Just drag the `PBWebViewController` folder to your project.

## Usage

**`PBWebViewController` requires iOS 6.0 and ARC.**

`PBWebViewController` works on iPhone and iPad in all orientations and is meant to be used in a `UINavigationController`. All you need to do is set up it's properties and then push it. Here's a simple example with comments:

```objective-c
// Initialize the web view controller and set it's URL
self.webViewController = [[PBWebViewController alloc] init];
self.webViewController.URL = [NSURL URLWithString:@"http://www.apple.com"];

// These are custom UIActivity subclasses that will show up in the UIActivityViewController
// when the action button is clicked
PBSafariActivity *activity = [[PBSafariActivity alloc] init];
self.webViewController.applicationActivities = @[activity];

// This property also corresponds to the same one on UIActivityViewController
// Both properties do not need to be set unless you want custom actions
self.webViewController.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToWeibo];

// Push it
[self.navigationController pushViewController:self.webViewController animated:YES];
```

See the example project for a little more advanced usage.

### Subclassing Notes

`PBWebViewController` can safely be subclassed to implement custom behaveour. Override `load`, and the `UIWebViewDelegate` methods to hook in, just don't forget to call super to take advantage of what `PBWebViewController` provides.

A simple subclass is used in the example project.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
