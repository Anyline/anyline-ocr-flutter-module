#import "ALPluginHelper.h"
#import <Anyline/Anyline.h>
#import "ALNFCScanViewController.h" // because NFC-specific code is there

@implementation ALPluginHelper

#pragma mark - Launch Anyline

+ (void)startScan:(NSDictionary *)config finished:(ALPluginCallback)callback {

    NSDictionary *pluginConf = config;
    
    NSString *licenseKey = [config objectForKey:@"licenseKey"];
    
    [[UIApplication sharedApplication] keyWindow].rootViewController.modalPresentationStyle = UIModalPresentationFullScreen;

    NSDictionary *optionsDict = [config objectForKey:@"options"];
    ALJSONUIConfiguration *jsonUIConf = [[ALJSONUIConfiguration alloc] initWithDictionary:optionsDict];

    BOOL isNFC = [optionsDict[@"enableNFCWithMRZ"] boolValue];

    if (isNFC) {
        if (@available(iOS 13.0, *)) {

            if (![ALNFCDetector readingAvailable]) {
                callback(nil, @"NFC passport reading is not supported on this device or app.");
                return;
            }
            
            ALNFCScanViewController *nfcScanViewController = [[ALNFCScanViewController alloc] initWithLicensekey:licenseKey
                                                                                                   configuration:pluginConf
                                                                                                        uiConfig:jsonUIConf
                                                                                                        finished:callback];
//            if ([pluginConf valueForKey:@"quality"]){
//                nfcScanViewController.quality = [[pluginConf valueForKey:@"quality"] integerValue];
//            }
//
//            if ([pluginConf valueForKey:@"cropAndTransformErrorMessage"]){
//                NSString *str = [pluginConf objectForKey:@"cropAndTransformErrorMessage"];
//                nfcScanViewController.cropAndTransformErrorMessage = str;
//            }
//
//            if ([pluginConf valueForKey:@"nativeBarcodeEnabled"]) {
//                nfcScanViewController.nativeBarcodeEnabled = [[pluginConf objectForKey:@"nativeBarcodeEnabled"] boolValue];
//            }

            if (nfcScanViewController != nil) {
                [nfcScanViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:nfcScanViewController
                                                                                               animated:YES
                                                                                             completion:nil];
            }
        } else {
            callback(nil, @"NFC passport reading is only supported on iOS 13 and later.");
            return;
        }
    } else {
        ALPluginScanViewController *pluginScanViewController = [[ALPluginScanViewController alloc] initWithLicensekey:licenseKey
                                                                                                        configuration:pluginConf
                                                                                                      uiConfiguration:jsonUIConf
                                                                                                             finished:callback];

        // TODO: should remove these extras
        if ([pluginConf valueForKey:@"quality"]){
            pluginScanViewController.quality = [[pluginConf valueForKey:@"quality"] integerValue];
        }

        if ([pluginConf valueForKey:@"cropAndTransformErrorMessage"]){
            NSString *str = [pluginConf objectForKey:@"cropAndTransformErrorMessage"];
            pluginScanViewController.cropAndTransformErrorMessage = str;
        }

        if ([pluginConf valueForKey:@"nativeBarcodeEnabled"]) {
            pluginScanViewController.nativeBarcodeEnabled = [[pluginConf objectForKey:@"nativeBarcodeEnabled"] boolValue];
        }

        if (pluginScanViewController) {
            [pluginScanViewController setModalPresentationStyle:UIModalPresentationFullScreen];
            [[[UIApplication sharedApplication] keyWindow].rootViewController presentViewController:pluginScanViewController
                                                                                           animated:YES
                                                                                         completion:nil];
        }
    }
}
#pragma mark - String convertions

+ (NSString *)barcodeFormatFromString:(NSString *)barcodeFormat {
    return (barcodeFormat == nil && barcodeFormat.length == 0) ? @"unkown" : barcodeFormat;
}

//+ (ALScanMode)scanModeFromString:(NSString *)scanMode {
//    NSDictionary<NSString *, NSNumber *> *scanModes = [ALPluginHelper scanModesDict];
//
//    return [scanModes[scanMode] integerValue];
//}
//
//+ (NSString *)stringFromScanMode:(ALScanMode)scanMode {
//    NSDictionary<NSString *, NSNumber *> *scanModes = [ALPluginHelper scanModesDict];
//
//    return [scanModes allKeysForObject:@(scanMode)][0];
//}
//
//+ (NSString *)stringForOutline:(ALSquare *)square {
//    return [NSString stringWithFormat:@"outline : { upLeft : { x : %f, y : %f }, upRight : { x : %f, y : %f }, downRight : { x : %f, y : %f }, downLeft : { x : %f, y : %f } }",square.upLeft.x,square.upLeft.y,square.upRight.x,square.upRight.y,square.downRight.x,square.downRight.y,square.downLeft.x,square.downLeft.y];
//}

//+ (NSDictionary<NSString *, NSNumber *> *)scanModesDict {
//    static NSDictionary<NSString *, NSNumber *> * scanModes = nil;
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        scanModes = @{
//                      @"AUTO_ANALOG_DIGITAL_METER" : @(ALAutoAnalogDigitalMeter),
//                      @"DIAL_METER" : @(ALDialMeter),
//                      @"ANALOG_METER" : @(ALAnalogMeter),
//                      @"BARCODE" : @(ALMeterBarcode),
//                      @"SERIAL_NUMBER" : @(ALSerialNumber),
//                      @"DOT_MATRIX_METER" : @(ALDotMatrixMeter),
//                      @"DIGITAL_METER" : @(ALDigitalMeter),
//                      @"HEAT_METER_4" : @(ALHeatMeter4),
//                      @"HEAT_METER_5" : @(ALHeatMeter5),
//                      @"HEAT_METER_6" : @(ALHeatMeter6),
//                      };
//    });
//
//    return scanModes;
//}

//+ (NSString *)barcodeFormatForNativeString:(NSString *)barcodeType {
//
//    static NSDictionary<NSString *, NSString *> * barcodeFormats = nil;
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wdeprecated-declarations"
//        barcodeFormats = @{
//                           @"AVMetadataObjectTypeUPCECode" : kCodeTypeUPCE,
//                           @"AVMetadataObjectTypeCode39Code" : kCodeTypeCode39,
//                           @"AVMetadataObjectTypeCode39Mod43Code" : kCodeTypeCode39,
//                           @"AVMetadataObjectTypeEAN13Code" : kCodeTypeEAN13,
//                           @"AVMetadataObjectTypeEAN8Code" : kCodeTypeEAN8,
//                           @"AVMetadataObjectTypeCode93Code" : kCodeTypeCode93,
//                           @"AVMetadataObjectTypeCode128Code" : kCodeTypeCode128,
//                           @"AVMetadataObjectTypePDF417Code" : kCodeTypePDF417,
//                           @"AVMetadataObjectTypeQRCode" : kCodeTypeQR,
//                           @"AVMetadataObjectTypeAztecCode" : kCodeTypeAztec,
//                           @"AVMetadataObjectTypeInterleaved2of5Code" : kCodeTypeITF,
//                           @"AVMetadataObjectTypeITF14Code" : kCodeTypeITF,
//                           @"AVMetadataObjectTypeDataMatrixCode" : kCodeTypeDataMatrix,
//                           };
//#pragma clang diagnostic pop
//    });
//
//    return barcodeFormats[barcodeType];
//}

#pragma mark - Filesystem handling

+ (NSString *)saveImageToFileSystem:(UIImage *)image {
    return [self saveImageToFileSystem:image compressionQuality:0.9];
}

+ (NSString *)saveImageToFileSystem:(UIImage *)image compressionQuality:(CGFloat)compressionQuality {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData *binaryImageData = UIImageJPEGRepresentation(image, compressionQuality);
    NSString *uuid = [NSUUID UUID].UUIDString;
    NSString *imagePath = [NSString stringWithFormat:@"%@.jpg",uuid];
    
    NSString *fullPath = [basePath stringByAppendingPathComponent:imagePath];
    [binaryImageData writeToFile:fullPath atomically:YES];
    
    return fullPath;
}

#pragma mark - UI helpers

+ (UILabel *)createLabelForView:(UIView *)view {
    
    UILabel *scannedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 44)];
    scannedLabel.center = CGPointMake(view.center.x, view.center.y+166);
    
    scannedLabel.alpha = 0.0;
    scannedLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:33];
    scannedLabel.textColor = [UIColor whiteColor];
    scannedLabel.textAlignment = NSTextAlignmentCenter;
    
    [view addSubview:scannedLabel];
    
    return scannedLabel;
}

//+ (UISegmentedControl *)createSegmentForViewController:(UIViewController *)viewController
//                                                config:(ALJsonUIConfiguration *)config
//                                              scanMode:(ALScanMode)scanMode {
//    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:config.segmentTitles];
//
//    segment.tintColor = config.segmentTintColor;
//    segment.hidden = YES;
//
//    NSInteger index = [config.segmentModes indexOfObject:[ALPluginHelper stringFromScanMode:scanMode]];
//    [segment setSelectedSegmentIndex:index];
//
//    [segment addTarget:viewController action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
//
//    [viewController.view addSubview:segment];
//
//    return segment;
//}

+ (UIButton *)createButtonForViewController:(UIViewController *)viewController
                                     config:(ALJSONUIConfiguration *)config {
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:config.buttonDoneTitle
                forState:UIControlStateNormal];
    
    [doneButton addTarget:viewController
                   action:@selector(doneButtonPressed:)
         forControlEvents:UIControlEventTouchUpInside];

    [viewController.view addSubview:doneButton];
    
    [ALPluginHelper updateButtonPosition:doneButton
                       withConfiguration:config
                                  onView:viewController.view];
    
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

+ (void)updateButtonPosition:(UIButton *)button
           withConfiguration:(ALJSONUIConfiguration *)conf
                      onView:(UIView *)view {
    
    button.titleLabel.font = [UIFont fontWithName:conf.buttonDoneFontName size:conf.buttonDoneFontSize];
    [button setTitleColor:conf.buttonDoneTextColor forState:UIControlStateNormal];
    [button setTitleColor:conf.buttonDoneTextColorHighlighted forState:UIControlStateHighlighted];
    
    button.backgroundColor = conf.buttonDoneBackgroundColor;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.layer.cornerRadius = conf.buttonDoneCornerRadius;
    
    switch (conf.buttonType) {
        case ALButtonTypeFullWidth:
            // Width constraint
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:1.0
                                                              constant:0]];
            break;
            
        case ALButtonTypeRect:
            [button sizeToFit];
            break;
            
        default:
            break;
    }
    
    switch (conf.buttonDoneXAlignment) {
        case ALButtonXAlignmentCenter:
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1.0
                                                              constant:conf.buttonDoneXPositionOffset]];
            break;
        case ALButtonXAlignmentLeft:
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:MAX(conf.buttonDoneXPositionOffset,0)]];
            break;
        case ALButtonXAlignmentRight:
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeRight
                                                            multiplier:1.0
                                                              constant:MIN(conf.buttonDoneXPositionOffset,0)]];
            break;
            
        default:
            break;
    }
    
    switch (conf.buttonDoneYAlignment) {
        case ALButtonYAlignmentTop:
            // Align Top
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:MAX(conf.buttonDoneYPositionOffset,0)]];
            break;
        case ALButtonYAlignmentBottom:
            // Align Bottom
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1.0
                                                              constant:MIN(conf.buttonDoneYPositionOffset,0)]];
            
            break;
        case ALButtonYAlignmentCenter:
            // Center vertically
            [view addConstraint:[NSLayoutConstraint constraintWithItem:button
                                                             attribute:NSLayoutAttributeCenterY
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeCenterY
                                                            multiplier:1.0
                                                              constant:conf.buttonDoneYPositionOffset]];
            break;
            
        default:
            break;
    }
}

#pragma mark - Date Parsing Utils

+ (NSString *)stringForDate:(NSDate *)date {
    if (!date) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC+0:00"]];
    [dateFormatter setDateFormat:@"EEE MMM d hh:mm:ss ZZZZ yyyy"];
    
    //Date will be formatted to string - e.g.: "Fri Jan 11 12:00:00 GMT+0:00 1980"
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

@end
