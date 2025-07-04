#import "ALPluginHelper.h"
#import "ALPluginScanViewController.h"
#import <Anyline/Anyline.h>
#import <objc/runtime.h>

// Predefined domain for errors from most AppKit and Foundation APIs.
NSErrorDomain const ALFlutterDomain = @"ALFlutterDomain";

@implementation ALPluginHelper

#pragma mark - Launch Anyline

+ (void)startScan:(NSDictionary *)config initializationParamsStr:(NSString *)initializationParamsStr finished:(ALPluginCallback)callback {
    
    NSDictionary *pluginConf = config;
    
    NSString *licenseKey = [config objectForKey:@"licenseKey"];
    
    UIViewController *presentingViewController = [self.class topMostViewController];
    presentingViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    NSDictionary *optionsDict = [config objectForKey:@"options"];
    ALJSONUIConfiguration *jsonUIConf = [[ALJSONUIConfiguration alloc] initWithDictionary:optionsDict];

    ALPluginScanViewController *pluginScanViewController = [[ALPluginScanViewController alloc] initWithLicensekey:licenseKey
                                                                                                    configuration:pluginConf
                                                                                                  uiConfiguration:jsonUIConf
                                                                                          initializationParamsStr:initializationParamsStr
                                                                                                         finished:callback];

    // TODO: should remove these extras
    if ([pluginConf valueForKey:@"quality"]){
        pluginScanViewController.quality = [[pluginConf valueForKey:@"quality"] integerValue];
    }

    if ([pluginConf valueForKey:@"cropAndTransformErrorMessage"]) {
        NSString *str = [pluginConf objectForKey:@"cropAndTransformErrorMessage"];
        pluginScanViewController.cropAndTransformErrorMessage = str;
    }

    if (pluginScanViewController) {
        [pluginScanViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [presentingViewController presentViewController:pluginScanViewController
                                               animated:YES
                                             completion:nil];
    }
}

#pragma mark - Filesystem handling

+ (NSString *)saveImageToFileSystem:(UIImage *)image {
    return [self saveImageToFileSystem:image compressionQuality:0.9];
}

+ (NSString *)saveImageToFileSystem:(UIImage *)image compressionQuality:(CGFloat)compressionQuality {
    NSString *basePath = [self applicationCachePath];
    NSData *binaryImageData = UIImageJPEGRepresentation(image, compressionQuality);
    NSString *uuid = [NSUUID UUID].UUIDString;
    NSString *imagePath = [NSString stringWithFormat:@"%@.jpg",uuid];
    NSString *fullPath = [basePath stringByAppendingPathComponent:imagePath];
    [binaryImageData writeToFile:fullPath atomically:YES];
    return fullPath;
}

+ (NSString *)applicationCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}

#pragma mark - UI helpers

+ (UILabel *)createLabelForView:(UIView *)view {
    
    UILabel *scannedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    scannedLabel.center = CGPointMake(view.center.x, view.center.y + 166);
    scannedLabel.alpha = 0.0;
    scannedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:32];
    scannedLabel.textColor = [UIColor whiteColor];
    scannedLabel.numberOfLines = 0;
    scannedLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:scannedLabel];
    
    return scannedLabel;
}

+ (UIToolbar *)createToolbarForViewController:(UIViewController *)viewController
                                     config:(ALJSONUIConfiguration *)config {
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.translucent = YES;
    toolbar.backgroundColor = [UIColor clearColor];
    
    // Create a back button with arrow icon
    UIBarButtonItem *backButton;
    if (@available(iOS 13.0, *)) {
        // Create a custom view that combines the image and text
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [customButton setImage:[UIImage systemImageNamed:@"chevron.left"] forState:UIControlStateNormal];
        [customButton setTitle:config.toolbarTitle forState:UIControlStateNormal];
        
        // Configure content alignment
        customButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        // Add some spacing between the image and text
        customButton.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        customButton.titleEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
        
        // Set a fixed width to prevent title changes from affecting alignment
        [customButton.widthAnchor constraintGreaterThanOrEqualToConstant:120].active = YES;
        
        [customButton addTarget:viewController 
                       action:@selector(doneButtonPressed:)
             forControlEvents:UIControlEventTouchUpInside];
        
        backButton = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    } else {
        // For older iOS versions, use the built-in back button style
        backButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"← %@", config.toolbarTitle]
                                                     style:UIBarButtonItemStylePlain
                                                    target:viewController
                                                    action:@selector(doneButtonPressed:)];
    }
    
    // Add a fixed space item to ensure consistent left alignment
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 16.0; // Adjust this value as needed for desired spacing
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    toolbar.items = @[fixedSpace, backButton, flexibleSpace];
    toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [viewController.view addSubview:toolbar];
    
    [toolbar.leftAnchor constraintEqualToAnchor:viewController.view.leftAnchor].active = YES;
    [toolbar.rightAnchor constraintEqualToAnchor:viewController.view.rightAnchor].active = YES;
    [toolbar.topAnchor constraintEqualToAnchor:viewController.view.safeAreaLayoutGuide.topAnchor].active = YES;
    
    return toolbar;
}

+ (UISegmentedControl *)createSegmentForViewController:(UIViewController *)viewController
                                                config:(ALJSONUIConfiguration *)config {
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:config.segmentTitles];
    
    // This doesn't appear to be changing the color
    // segment.tintColor = ...
    
    segment.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    if (@available(iOS 13.0, *)) {
        segment.selectedSegmentTintColor = config.segmentTintColor;
    }
    
    segment.hidden = YES;
    
    // [segment setSelectedSegmentIndex:index];
    [segment setSelectedSegmentIndex:0];
    
    // has a warning here but is okay as long as the target implements this selector.
    [segment addTarget:viewController action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    
    [viewController.view addSubview:segment];
    
    return segment;
}

+ (UIButton *)createButtonForViewController:(UIViewController *)viewController
                                     config:(ALJSONUIConfiguration *)config
                                    refView:(UIView *)refView {
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:config.buttonDoneTitle forState:UIControlStateNormal];
    
    // NOTE: there'll be a warning here from Xcode but just have to make sure
    // doneButtonPressed: is a valid selector in the target
    [doneButton addTarget:viewController action:@selector(doneButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [viewController.view addSubview:doneButton];
    
    [ALPluginHelper updateButtonAppearance:doneButton
                         withConfiguration:config
                                    onView:viewController.view];

    [ALPluginHelper updateButtonPosition:doneButton
                              xAlignment:config.buttonDoneXAlignment
                              yAlignment:config.buttonDoneYAlignment
                         xPositionOffset:config.buttonDoneXPositionOffset
                         yPositionOffset:config.buttonDoneYPositionOffset
                           containerView:viewController.view
                                 refView:refView];
    return doneButton;
}

+ (ALRoundedView *)createRoundedViewForViewController:(UIViewController *)viewController {
    ALRoundedView *roundedView = [[ALRoundedView alloc] initWithFrame:CGRectMake(20, 115, viewController.view.bounds.size.width - 40, 30)];
    roundedView.fillColor = [UIColor colorWithRed:98.0/255.0 green:39.0/255.0 blue:232.0/255.0 alpha:0.6];
    roundedView.textLabel.text = @"";
    roundedView.alpha = 0;
    [viewController.view addSubview:roundedView];
    return roundedView;
}

+ (void)updateButtonAppearance:(UIButton *)button
             withConfiguration:(ALJSONUIConfiguration *)config
                        onView:(UIView *)view {
    
    button.titleLabel.font = [UIFont fontWithName:config.buttonDoneFontName size:config.buttonDoneFontSize];
    [button setTitleColor:config.buttonDoneTextColor forState:UIControlStateNormal];
    [button setTitleColor:config.buttonDoneTextColorHighlighted forState:UIControlStateHighlighted];
    button.contentEdgeInsets = UIEdgeInsetsMake(6, 10, 6, 10);
    
    
    button.backgroundColor = config.buttonDoneBackgroundColor;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // corner radius is overridden to 0 when "full-width" type is used
    button.layer.cornerRadius = config.buttonDoneCornerRadius;
    
    switch (config.buttonType) {
        case ALButtonTypeFullWidth: // "FULLWIDTH"
            [view addConstraint:[button.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:0]];
            [view addConstraint:[button.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:0]];
            button.layer.cornerRadius = 0;
            break;
        case ALButtonTypeRect: // "RECT"
            [button sizeToFit];
            break;
            
        default:
            break;
    }
}

+ (void)updateButtonPosition:(UIButton *)button
                  xAlignment:(ALButtonXAlignment)buttonXAlignment
                  yAlignment:(ALButtonYAlignment)buttonYAlignment
             xPositionOffset:(CGFloat)buttonXPositionOffset
             yPositionOffset:(CGFloat)buttonYPositionOffset
               containerView:(UIView *)containerView
                     refView:(UIView *)refView {


    
    switch (buttonXAlignment) {
        case ALButtonXAlignmentCenter:
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:refView
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:buttonXPositionOffset]];
            break;
        case ALButtonXAlignmentLeft:
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:refView
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:MAX(buttonXPositionOffset, 0)]];
            break;
        case ALButtonXAlignmentRight:
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:refView
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:MIN(buttonXPositionOffset, 0)]];
            break;
            
        default:
            break;
    }
    
    switch (buttonYAlignment) {
        case ALButtonYAlignmentTop:
            // Align Top
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:refView
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:MAX(buttonYPositionOffset, 0)]];
            break;
        case ALButtonYAlignmentBottom:
            // Align Bottom
            [containerView addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:refView
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:MIN(buttonYPositionOffset, 0)]];
            
            break;
        case ALButtonYAlignmentCenter:
            // Center vertically
            [containerView addConstraint:
                 [button.centerYAnchor constraintEqualToAnchor:refView.centerYAnchor constant:buttonYPositionOffset]
            ];
            break;
            
        default:
            break;
    }
}

// MARK: Utilities

+ (void)showErrorAlertWithTitle:(NSString *)title
                        message:(NSString *)message
       presentingViewController:(UIViewController *)presentingViewController {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [presentingViewController presentViewController:alertController animated:YES completion:nil];
}

+ (BOOL)showErrorAlertIfNeeded:(NSError *)error
                pluginCallback:(ALPluginCallback)callback {
    
    if (!error) {
        return NO;
    }
    
    UIViewController *fromViewController = [self.class topMostViewController];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not start scanning"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
        
        [fromViewController dismissViewControllerAnimated:YES completion:^{
            callback(nil, [NSError errorWithDomain:@"" code:-1 userInfo:@{@"Error reason": @"Canceled"}]);
        }];
    }];
    
    [alert addAction:action];
    [fromViewController presentViewController:alert animated:YES completion:NULL];
    return YES;
}

+ (NSError *)errorWithMessage:(NSString *)message {
    return [NSError errorWithDomain:ALFlutterDomain code:1000 userInfo:@{ NSLocalizedDescriptionKey: message }];
}

// MARK: - Date Utils

+ (UIViewController *)topMostViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    }
    return vc;
}

+ (NSDate * _Nullable)formattedStringToDate:(NSString *)formattedStr {
    // From this: "Sun Apr 12 00:00:00 UTC 1977" to this: "04/12/1977"
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    dateFormatter.dateFormat = @"E MMM d HH:mm:ss zzz yyyy";
    NSDate *d = [dateFormatter dateFromString:formattedStr];
    return d;
}

+ (NSString *)stringForDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+0:00"]];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    return [dateFormatter stringFromDate:date];
}

@end
