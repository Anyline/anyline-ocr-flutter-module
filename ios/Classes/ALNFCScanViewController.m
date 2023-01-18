#import <Anyline/Anyline.h>
#import "ALNFCScanViewController.h"
#import "ALPluginHelper.h"

API_AVAILABLE(ios(13.0))
@interface ALNFCScanViewController () <ALNFCDetectorDelegate, ALScanPluginDelegate, ALScanViewDelegate>

@property (nonatomic, strong) ALPluginCallback callback;

@property (nonatomic, strong) NSDictionary *config;

@property (nonatomic, copy) NSString *licenseKey;

@property (nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) ALScanViewPlugin *mrzScanViewPlugin;

@property (nonatomic, strong) ALNFCDetector *nfcDetector;

// the result from NFC scanning is retained while NFC reading is initiated, and the results aggregated later
@property (nonatomic, strong) NSMutableDictionary *resultDict;

// TODO: make sure the following use the `options` group in the uiConfig
// BOOL showingLabel
// UILabel scannedLabel
// ALRoundedView
// Segment
@property (nonatomic, strong) ALJSONUIConfiguration *uiConfig;

@property (nonatomic, strong) UIView *hintView;

@property (nonatomic, strong) UIButton *doneButton;

// keep the last values we read from the MRZ so we can retry reading NFC
// if NFC failed for reasons other than getting these details wrong
@property (nonatomic, copy) NSString *passportNumberForNFC;

@property (nonatomic, strong) NSDate *dateOfBirth;

@property (nonatomic, strong) NSDate *dateOfExpiry;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *detectedBarcodes;

@property (nonatomic, assign) BOOL nativeBarcodeEnabled;

// not used
@property (nonatomic, strong) NSString *cropAndTransformErrorMessage;

// JPEG compression quality 0-100
@property (nonatomic, assign) NSUInteger quality;


@end


@implementation ALNFCScanViewController

- (instancetype)initWithLicensekey:(NSString *)licensekey
                     configuration:(NSDictionary *)anylineConfig
                          uiConfig:(ALJSONUIConfiguration *)uiConfig
                          finished:(ALPluginCallback)callback {
    if (self = [super init]) {
        _licenseKey = licensekey;
        _callback = callback;
        _config = anylineConfig;
        _uiConfig = uiConfig;
        
        self.quality = 90;
        self.nativeBarcodeEnabled = NO;
        self.cropAndTransformErrorMessage = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // NOTE: NFCDetector can throw an exception if the AnylineSDK isn't initialized first
    // as it will check the scope value of the license
    NSError *error = nil;
    [AnylineSDK setupWithLicenseKey:self.licenseKey error:&error];
    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }

    if (@available(iOS 13.0, *)) {
        self.nfcDetector = [[ALNFCDetector alloc] initWithDelegate:self error:&error];
        if (!self.nfcDetector && error) {
            [self showErrorAlertIfNeeded:error];
            return;
        }
        if (![ALNFCDetector readingAvailable]) {
            [self showAlertWithTitle:@"Error" message:@"NFC is not available"];
            return;
        }
    } else {
        // application should have prevented you from even loading this view controller
        [self showAlertWithTitle:@"Error" message:@"iOS 13.0 or newer is required to scan with MRZ / NFC."];
        return;
    }

    [self.view addSubview:self.scanView];

    self.resultDict = [[NSMutableDictionary alloc] init];
    self.detectedBarcodes = [NSMutableArray array];

    self.scanView = [ALScanViewFactory withJSONDictionary:self.config delegate:self error:&error];
    self.scanView.delegate = self;

    [self configureMRZPlugin];

    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }

    self.mrzScanViewPlugin = (ALScanViewPlugin *)self.scanView.scanViewPlugin;

    // TODO: force the flash alignment to go top left.
    // self.scanView.flashButtonConfig.flashAlignment = ALFlashAlignmentTopLeft;
    
    [self.view addSubview:self.scanView];

    self.scanView.translatesAutoresizingMaskIntoConstraints = false;
    [self.scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    [self.scanView startCamera];

    self.hintView = [self.class hintView];
    [self.view addSubview:self.hintView];
    self.hintView.center = CGPointMake(self.view.center.x, 0);

    self.doneButton = [ALPluginHelper createButtonForViewController:self config:self.uiConfig];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSError *error;
    [self startMRZScanning:&error];
    [self showErrorAlertIfNeeded:error];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopMRZScanning];
    [super viewDidDisappear:animated];
}

- (void)startMRZScanning:(NSError **)error {
    [self.mrzScanViewPlugin startWithError:error];
    self.hintView.hidden = NO;
}

- (void)stopMRZScanning {
    [self.mrzScanViewPlugin stop];
    self.hintView.hidden = YES;
}

- (void)configureMRZPlugin {

    ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)self.scanView.scanViewPlugin;
    if (![scanViewPlugin isKindOfClass:ALScanViewPlugin.class]) {
        return;
    }

    ALCutoutConfig *cutoutConfig = scanViewPlugin.scanViewPluginConfig.cutoutConfig;
    ALScanFeedbackConfig *scanFeedbackConfig = scanViewPlugin.scanViewPluginConfig.scanFeedbackConfig;

    ALPluginConfig *pluginConfig = scanViewPlugin.scanPlugin.scanPluginConfig.pluginConfig;
    ALMrzConfig *mrzConfig = pluginConfig.mrzConfig;

    // a bit lengthy but this is how you properly change the config (mrzFieldScanOptions and mrzMinFieldConfidences)
    // taking into account the readonly config fields
    mrzConfig.mrzFieldScanOptions = [[ALMrzFieldScanOptions alloc] init];

    mrzConfig.mrzFieldScanOptions.vizAddress = ALMrzScanOption.mrzScanOptionDefault;
    mrzConfig.mrzFieldScanOptions.vizDateOfIssue = ALMrzScanOption.mrzScanOptionDefault;
    mrzConfig.mrzFieldScanOptions.vizSurname = ALMrzScanOption.mrzScanOptionDefault;
    mrzConfig.mrzFieldScanOptions.vizGivenNames = ALMrzScanOption.mrzScanOptionDefault;
    mrzConfig.mrzFieldScanOptions.vizDateOfBirth = ALMrzScanOption.mrzScanOptionDefault;
    mrzConfig.mrzFieldScanOptions.vizDateOfExpiry = ALMrzScanOption.mrzScanOptionDefault;

    mrzConfig.mrzMinFieldConfidences = [[ALMrzMinFieldConfidences alloc] init];
    mrzConfig.mrzMinFieldConfidences.documentNumber = @(90);
    mrzConfig.mrzMinFieldConfidences.dateOfBirth = @(90);
    mrzConfig.mrzMinFieldConfidences.dateOfExpiry = @(90);

    NSError *error;
    ALScanViewPluginConfig *scanViewPluginConfig = [ALScanViewPluginConfig withScanPluginConfig:[ALScanPluginConfig withPluginConfig:pluginConfig]
                                                                                   cutoutConfig:cutoutConfig
                                                                             scanFeedbackConfig:scanFeedbackConfig];
    ALScanViewPlugin *updatedScanViewPlugin = [[ALScanViewPlugin alloc] initWithConfig:scanViewPluginConfig error:&error];
    [self.scanView setScanViewPlugin:updatedScanViewPlugin error:&error];

    // the delegate binding was lost when you recreated the ScanPlugin it so you have to bring it back here
    scanViewPlugin = (ALScanViewPlugin *)self.scanView.scanViewPlugin;
    scanViewPlugin.scanPlugin.delegate = self;
}

// MARK: - ALIDPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {

    // ACO just a failsafe for when cancelOnResult is not true
    [self stopMRZScanning];

    self.resultDict = [NSMutableDictionary dictionaryWithDictionary:scanResult.resultDictionary];

    ALMrzResult *MRZResult = scanResult.pluginResult.mrzResult;
    NSString *passportNumber = [MRZResult.documentNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    self.dateOfBirth = [self.class formattedStringToDate:MRZResult.dateOfBirthObject];

    self.dateOfExpiry = [self.class formattedStringToDate:MRZResult.dateOfExpiryObject];

    NSMutableString *passportNumberForNFC = [passportNumber mutableCopy];
    NSRange passportNumberRange = [MRZResult.mrzString rangeOfString:passportNumber];
    if (passportNumberRange.location != NSNotFound) {
        if ([MRZResult.mrzString characterAtIndex:NSMaxRange(passportNumberRange)] == '<') {
            [passportNumberForNFC appendString:@"<"];
        }
    }

    self.passportNumberForNFC = passportNumberForNFC;

    [self.nfcDetector startNfcDetectionWithPassportNumber:self.passportNumberForNFC
                                              dateOfBirth:self.dateOfBirth
                                           expirationDate:self.dateOfExpiry];
}

- (void)handleResult:(id _Nullable)resultObj {

    NSObject<ALScanViewPluginBase> *scanViewPluginBase = self.scanView.scanViewPlugin;
    // TODO: handle this for composites: cancelOnResult = true? dismiss
    if ([scanViewPluginBase isKindOfClass:ALScanViewPlugin.class]) {
        ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)scanViewPluginBase;
        BOOL cancelOnResult = scanViewPlugin.scanPlugin.scanPluginConfig.cancelOnResult;
        if (cancelOnResult) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ([scanViewPluginBase isKindOfClass:ALViewPluginComposite.class]) {
        // for composites, the cancelOnResult values for each child don't matter
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    self.callback(resultObj, nil);

    // self.detectedBarcodes = [NSMutableArray array];
}

- (void)doneButtonPressed:(id)sender {
    [self stopMRZScanning];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.callback(nil, @"Canceled");
    }];
}

// MARK: - ALNFCDetectorDelegate

- (void)nfcSucceededWithResult:(ALNFCResult * _Nonnull)nfcResult API_AVAILABLE(ios(13.0)) {

    // DataGroup1
    NSMutableDictionary *dictResultDataGroup1 = [[NSMutableDictionary alloc] init];


    [dictResultDataGroup1 setValue:[self.class stringForDate:nfcResult.dataGroup1.dateOfBirth]
                            forKey:@"dateOfBirth"];
    [dictResultDataGroup1 setValue:[self.class stringForDate:nfcResult.dataGroup1.dateOfExpiry]
                            forKey:@"dateOfExpiry"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.documentNumber forKey:@"documentNumber"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.documentType forKey:@"documentType"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.firstName forKey:@"firstName"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.gender forKey:@"gender"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.issuingStateCode forKey:@"issuingStateCode"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.lastName forKey:@"lastName"];
    [dictResultDataGroup1 setValue:nfcResult.dataGroup1.nationality forKey:@"nationality"];

    [self.resultDict setObject:dictResultDataGroup1 forKey:@"dataGroup1"];

    // DataGroup2
    // ACO: we don't put the path into a separate 'dataGroup' category for the wrapper
    NSString *imagePath = [ALPluginHelper saveImageToFileSystem:nfcResult.dataGroup2.faceImage
                                             compressionQuality:self.quality / (CGFloat)100.0f];

    // SOB
    NSMutableDictionary *dictResultSOB = [[NSMutableDictionary alloc] init];

    [dictResultSOB setValue:nfcResult.sod.issuerCertificationAuthority forKey:@"issuerCertificationAuthority"];
    [dictResultSOB setValue:nfcResult.sod.issuerCountry forKey:@"issuerCountry"];
    [dictResultSOB setValue:nfcResult.sod.issuerOrganization forKey:@"issuerOrganization"];
    [dictResultSOB setValue:nfcResult.sod.issuerOrganizationalUnit forKey:@"issuerOrganizationalUnit"];
    [dictResultSOB setValue:nfcResult.sod.ldsHashAlgorithm forKey:@"ldsHashAlgorithm"];
    [dictResultSOB setValue:nfcResult.sod.signatureAlgorithm forKey:@"signatureAlgorithm"];
    [dictResultSOB setValue:nfcResult.sod.validFromString forKey:@"validFromString"];
    [dictResultSOB setValue:nfcResult.sod.validUntilString forKey:@"validUntilString"];

    [self.resultDict setObject:dictResultSOB forKey:@"sob"];

    [self.resultDict setValue:imagePath forKey:@"imagePath"];

    __weak __block typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf handleResult:weakSelf.resultDict];
    });
}

- (void)nfcFailedWithError:(NSError * _Nonnull)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error.code == ALNFCTagErrorNFCNotSupported) {
            [self showAlertWithTitle:@"NFC Not Supported"
                             message:@"NFC passport reading is not supported on this device."];
        }
        if (error.code == ALNFCTagErrorResponseError || // MRZ key was likely wrong
            error.code == ALNFCTagErrorUnexpectedError) {
            // can mean the user pressed the 'Cancel' button while scanning, or the phone lost the
            // connection with the NFC chip because it was moved
            [self startMRZScanning:nil]; //run the MRZ scanner so we can try again.
        } else {
            // the MRZ details are correct, but something else went wrong. We can try reading
            // the NFC chip again without rescanning the MRZ.
            __weak __block typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.nfcDetector startNfcDetectionWithPassportNumber:weakSelf.passportNumberForNFC
                                                              dateOfBirth:weakSelf.dateOfBirth
                                                           expirationDate:weakSelf.dateOfExpiry];
            });
        }
    });
}

// MARK: - ALScanViewDelegate

- (void)scanView:(ALScanView *)scanView updatedCutoutWithPluginID:(NSString *)pluginID frame:(CGRect)frame {
    // position the hintView above the cutout.

    CGFloat yOrigin = frame.origin.y;

    self.hintView.hidden = YES;
    if (yOrigin >= 0) {
        self.hintView.hidden = NO;
    }

    [self updateHintPosition:yOrigin];
}

// MARK: - Alerts

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:dismissAction];
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)showErrorAlertIfNeeded:(NSError *)error {
    if (!error) {
        return NO;
    }

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

// MARK: - User Interface

// TODO: position this properly according to the cutout
+ (UIView *)hintView {
    CGFloat hintMargin = 7;
    UILabel *hintViewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UIView *hintView = [[UILabel alloc] initWithFrame:CGRectZero];
    hintViewLabel.text = @"Scan MRZ";
    [hintViewLabel sizeToFit];
    [hintView addSubview:hintViewLabel];
    hintView.frame = UIEdgeInsetsInsetRect(hintViewLabel.frame,
                                           UIEdgeInsetsMake(-hintMargin, -hintMargin, -hintMargin, -hintMargin));
    hintViewLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [hintViewLabel.centerYAnchor constraintEqualToAnchor:hintView.centerYAnchor constant:0].active = YES;
    [hintViewLabel.centerXAnchor constraintEqualToAnchor:hintView.centerXAnchor constant:0].active = YES;
    hintView.layer.cornerRadius = 8;
    hintView.layer.masksToBounds = true;
    hintView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hintViewLabel.textColor = [UIColor whiteColor];
    return hintView;
}

- (void)updateHintPosition:(CGFloat)newPosition {
    self.hintView.center = CGPointMake(self.hintView.center.x, newPosition);
}

+ (NSDate *)formattedStringToDate:(NSString *)formattedStr {
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
