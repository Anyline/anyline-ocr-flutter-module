#import <Anyline/Anyline.h>

#import "ALPluginScanViewController.h"
#import "ALPluginHelper.h"
#import "ALPluginResultHelper.h"
#import "ALRoundedView.h"

@interface ALPluginScanViewController () <ALScanPluginDelegate, ALScanViewPluginDelegate>

// ACO should it have the `assign` attribute?
@property (nonatomic) ALPluginCallback callback;

@property (nonatomic, strong) NSDictionary *anylineConfig;

@property (nonatomic, copy) NSString *licenseKey;

@property (nonatomic, strong) ALJsonUIConfiguration *uiConfig;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UILabel *scannedLabel;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) ALRoundedView *roundedView;

// ACO what label?
@property (nonatomic, assign) BOOL showingLabel;

@property (nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *detectedBarcodes;

@end


@implementation ALPluginScanViewController

- (instancetype)initWithLicensekey:(NSString *)licensekey
                     configuration:(NSDictionary *)anylineConfig
                   uiConfiguration:(ALJsonUIConfiguration *)jsonUIConfig
                          finished:(ALPluginCallback)callback {

    if (self = [super init]) {
        _licenseKey = licensekey;
        _callback = callback;
        _anylineConfig = anylineConfig;
        _uiConfig = jsonUIConfig;
        
        self.quality = 100;
        self.nativeBarcodeEnabled = NO;
        self.cropAndTransformErrorMessage = @"";
    }
    return self;
}

/// <#Description#>
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;

    // ACO is there an equivalent place to that of an AppDelegate on which this could be added?
    [AnylineSDK setupWithLicenseKey:self.licenseKey error:&error];

    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }

    // TODO: scanviewfactory == nil: why no error?
    self.scanView = [ALScanViewFactory withJSONDictionary:self.anylineConfig
                                                 delegate:self
                                                    error:&error];

    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }
    [self.view addSubview:self.scanView];

    // TODO: configure the layout of the ScanView
    self.scanView.translatesAutoresizingMaskIntoConstraints = false;
    [self.scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    // self.scanView.delegate = self; // if needed

    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }
    
    [self.scanView startCamera];

    // ACO add a segmented view to switch between various scan modes.

//    if (self.uiConfig.segmentModes && [self.scanView.scanViewPlugin isKindOfClass:[ALMeterScanViewPlugin class]]) {
//        self.segment = [ALPluginHelper createSegmentForViewController:self
//                                                               config:self.uiConfig
//                                                             scanMode:((ALMeterScanViewPlugin *)self.scanView.scanViewPlugin).meterScanPlugin.scanMode];
//        [(ALMeterScanViewPlugin *)self.scanView.scanViewPlugin addScanViewPluginDelegate:self];
//    }

    // TODO: handle native barcode, if config specifies it.
    
    
//    if (self.nativeBarcodeEnabled) {
//        error = nil;
//        BOOL success = [self.scanView.captureDeviceManager addBarcodeDelegate:self error:&error];
//        if (!success) {
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not start scanning" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
//            [self presentViewController:alert animated:YES completion:NULL];
//
//            UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                [self dismissViewControllerAnimated:YES completion:^{
//                    self.callback(nil, @"Canceled");
//                }];
//            }];
//            [alert addAction:action];
//            return;
//        }
//    }
    
    self.detectedBarcodes = [NSMutableArray array];
    
    self.doneButton = [ALPluginHelper createButtonForViewController:self config:self.uiConfig];
    
    self.scannedLabel = [ALPluginHelper createLabelForView:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // avoid allowing the app to be put to sleep after a long period without touch events
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    NSError *error;
    [self.scanView.scanViewPlugin startWithError:&error];

    [self showErrorAlertIfNeeded:error];

    // TODO add segment if config asks for it
//    if (self.uiConfig.segmentModes) {
//        self.segment.frame = CGRectMake(self.scanView.scanViewPlugin.cutoutRect.origin.x + self.uiConfig.segmentXPositionOffset / 2.0,
//                                        self.scanView.scanViewPlugin.cutoutRect.origin.y + self.uiConfig.segmentYPositionOffset / 2.0,
//                                        self.view.frame.size.width - 2 * (self.scanView.scanViewPlugin.cutoutRect.origin.x + self.uiConfig.segmentXPositionOffset / 2.0),
//                                        self.segment.frame.size.height);
//        self.segment.hidden = NO;
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)doneButtonPressed:(id)sender {
    [self.scanView.scanViewPlugin stop];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.callback(nil, @"Canceled");
    }];
}

- (void)segmentChange:(id)sender {
    // TODO: implement method if still needed.
//    NSString *modeString = self.uiConfig.segmentModes[((UISegmentedControl *)sender).selectedSegmentIndex];
//    ALScanMode scanMode = [ALPluginHelper scanModeFromString:modeString];
//    if ([self.scanView.scanViewPlugin isKindOfClass:[ALMeterScanViewPlugin class]]) {
//        [((ALMeterScanViewPlugin *)self.scanView.scanViewPlugin).meterScanPlugin setScanMode:scanMode error:nil];
//    }
}

- (BOOL)showErrorAlertIfNeeded:(NSError *)error {
    if (error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Could not start scanning"
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:^{
                self.callback(nil, @"Canceled");
            }];
        }];

        [alert addAction:action];

        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert
                                                                                     animated:YES
                                                                                   completion:NULL];
        return YES;
    }
    return NO;
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {
    // for now the second param is not used.

    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithDictionary:scanResult.resultDictionary];

    NSString *imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.croppedImage];
    resultDict[@"imagePath"] = imagePath;

    imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.fullSizeImage];
    resultDict[@"fullImagePath"] = imagePath;

    [self handleResult:resultDict result:scanResult];
}

//- (void)scanPlugin:(ALScanPlugin *)scanPlugin errorReceived:(ALEvent *)event {
//
//    // call showUserLabel. This is for the document scan problems (we don't have it now)
//}


//- (void)anylineScanPlugin:(ALAbstractScanPlugin * _Nonnull)anylineScanPlugin
//               runSkipped:(ALRunSkippedReason * _Nonnull)runSkippedReason {
//
//    switch (runSkippedReason.reason) {
//        case ALRunFailurePointsOutOfCutout: {
//            NSLog(@"Failure: points out of bounce");
//
//            self.roundedView.textLabel.text = self.cropAndTransformErrorMessage;
//
//            // Animate the appearance of the label
//            CGFloat fadeDuration = 1.5;
//
//            // Check for Strict Mode and set it
//            if( self.showingLabel == 0){
//                self.showingLabel = 1;
//                [UIView animateWithDuration:fadeDuration animations:^{
//                    self.roundedView.alpha = 1;
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:fadeDuration animations:^{
//                        self.roundedView.alpha = 0;
//                    } completion:^(BOOL finished) {
//                        self.showingLabel = 0;
//                    }];
//                }];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}

- (void)handleResult:(NSDictionary *)dictResult result:(ALScanResult *)scanResult {

    // TODO: give the string version of the result to the self.scannedLabel label (if applicable)
//    if ([scanResult.result isKindOfClass:[NSString class]]) {
//        self.scannedLabel.text = (NSString *)scanResult.result;
//    }
    
    self.callback(dictResult, nil);

    // TODO: handle this for composites: cancelOnResult = true? dismiss
    if ([self.scanView.scanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        if (((ALScanViewPlugin *)self.scanView.scanViewPlugin).scanPlugin.scanPluginConfig.cancelOnResult) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

    self.detectedBarcodes = [NSMutableArray array];
}

//- (void)showUserLabel:(ALDocumentError)error {
//    NSString *helpString = nil;
//    switch (error) {
//        case ALDocumentErrorNotSharp:
//            helpString = @"Document not Sharp";
//            break;
//        case ALDocumentErrorSkewTooHigh:
//            helpString = @"Wrong Perspective";
//            break;
//        case ALDocumentErrorImageTooDark:
//            helpString = @"Too Dark";
//            break;
//        case ALDocumentErrorShakeDetected:
//            helpString = @"Too much shaking";
//            break;
//        default:
//            break;
//    }
//
//    // The error is not in the list above or a label is on screen at the moment
//    if(!helpString || self.showingLabel) {
//        return;
//    }
//
//    self.showingLabel = YES;
//    self.roundedView.textLabel.text = helpString;
//
//
//    // Animate the appearance of the label
//    CGFloat fadeDuration = 0.8;
//    [UIView animateWithDuration:fadeDuration animations:^{
//        self.roundedView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:fadeDuration animations:^{
//            self.roundedView.alpha = 0;
//        } completion:^(BOOL finished) {
//            self.showingLabel = NO;
//        }];
//    }];
//}

@end
