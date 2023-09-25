#import <Anyline/Anyline.h>
#import "ALPluginScanViewController.h"
#import "ALPluginHelper.h"
#import "ALRoundedView.h"
#import "AnylinePlugin.h"

@interface ALPluginScanViewController () <ALScanPluginDelegate, ALViewPluginCompositeDelegate, ALScanViewDelegate>

// ACO should it have the `assign` attribute?
@property (nonatomic, strong) ALPluginCallback callback;

@property (nonatomic, strong) NSDictionary *config;

@property (nonatomic, copy) NSString *licenseKey;

@property (nonatomic, strong) ALJSONUIConfiguration *uiConfig;

@property (nonatomic, strong) ALScanView *scanView;

@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) UILabel *scannedLabel;

@property (nonatomic, strong) ALRoundedView *roundedView;

@property (nonatomic, strong) UISegmentedControl *segment;

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *detectedBarcodes;

@property (nonatomic, strong) NSLayoutConstraint *labelHorizontalOffsetConstraint;

@property (nonatomic, strong) NSLayoutConstraint *labelVerticalOffsetConstraint;

@end


@implementation ALPluginScanViewController

- (void)dealloc {
    // NSLog(@"ACO dealloc ALPluginScanViewController");
}

- (instancetype)initWithLicensekey:(NSString *)licenseKey
                     configuration:(NSDictionary *)config
                   uiConfiguration:(ALJSONUIConfiguration *)JSONUIConfig
                          finished:(ALPluginCallback)callback {

    if (self = [super init]) {
        _licenseKey = licenseKey;
        _callback = callback;
        _config = config;
        _uiConfig = JSONUIConfig;
        
        self.quality = 100;
        self.cropAndTransformErrorMessage = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;

    self.view.backgroundColor = [UIColor blackColor];

    self.scanView = [ALScanViewFactory withJSONDictionary:self.config
                                                 delegate:self
                                                    error:&error];

    if ([self showErrorAlertIfNeeded:error]) {
        return;
    }

    [self.view addSubview:self.scanView];

    self.scanView.translatesAutoresizingMaskIntoConstraints = false;
    [self.scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

    self.scanView.supportedNativeBarcodeFormats = self.uiConfig.nativeBarcodeFormats;
    self.scanView.delegate = self;
    self.detectedBarcodes = [NSMutableArray array];

    self.doneButton = [ALPluginHelper createButtonForViewController:self config:self.uiConfig];

    self.scannedLabel = [ALPluginHelper createLabelForView:self.view];

    [self configureLabel:self.scannedLabel config:self.uiConfig];

    [self configureSegmentControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.scanView startCamera];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // avoid allowing the app to be put to sleep after a long period without touch events
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    NSError *error;
    [self.scanView.scanViewPlugin startWithError:&error];
    [self showErrorAlertIfNeeded:error];
}

- (void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotate {
    return NO;
}

/// The segment control contains a list of scan modes each of which, when selected, reloads the scan view with
/// the appropriate scan mode for the active plugin (keeping everything else the same)
- (void)configureSegmentControl {

    // At this point, you can safely create segment controls.
    if (!self.uiConfig.segmentViewConfigs) {
        return;
    }

    if (![self segmentModesAreValid]) {
        return;
    }

    // Give it the current scanmode that's initially defined already in the config JSON
    self.segment = [ALPluginHelper createSegmentForViewController:self
                                                           config:self.uiConfig];

    self.segment.hidden = NO;
    self.segment.translatesAutoresizingMaskIntoConstraints = NO;
    [self.segment.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.segment.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor
                                              constant:self.uiConfig.segmentYPositionOffset].active = YES;

    // NOTE: uncomment this to show the segment full width
    [self.segment.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
}

- (void)configureLabel:(UILabel *)label config:(ALJSONUIConfiguration *)config {

    if (config.labelText.length < 1) {
        return;
    }

    label.alpha = 1;
    label.text = config.labelText;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:config.labelSize];
    label.textColor = config.labelColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [label.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;

    self.labelHorizontalOffsetConstraint = [label.centerXAnchor
                                            constraintEqualToAnchor:self.view.centerXAnchor constant:0];
    self.labelVerticalOffsetConstraint = [label.bottomAnchor
                                          constraintEqualToAnchor:self.view.topAnchor
                                          constant:0];

    self.labelHorizontalOffsetConstraint.active = YES;
    self.labelVerticalOffsetConstraint.active = YES;
}

- (void)handleResult:(id _Nullable)resultObj {

    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithDictionary:resultObj];

    if (self.detectedBarcodes.count) {
        resultDictionary[@"nativeBarcodesDetected"] = self.detectedBarcodes;
    }

    // dismiss the view controller, if cancelOnResult for the config is true
    NSObject<ALScanViewPluginBase> *scanViewPluginBase = self.scanView.scanViewPlugin;
    if ([scanViewPluginBase isKindOfClass:ALScanViewPlugin.class]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)scanViewPluginBase;
        BOOL cancelOnResult = scanViewPlugin.scanPlugin.pluginConfig.cancelOnResult;
        if (cancelOnResult) {
            self.callback(resultDictionary, nil);
        }
    } else if ([scanViewPluginBase isKindOfClass:ALViewPluginComposite.class]) {
        // for composites, the cancelOnResult values for each child don't matter
        [self dismissViewControllerAnimated:YES completion:nil];
        self.callback(resultDictionary, nil);
    }
}

// MARK: - ALScanPluginDelegate

- (void)scanPlugin:(ALScanPlugin *)scanPlugin resultReceived:(ALScanResult *)scanResult {

    CGFloat compressionQuality = self.quality / 100.0f;

    NSMutableDictionary *resultDictMutable = [NSMutableDictionary dictionaryWithDictionary:scanResult.resultDictionary];

    NSString *imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.croppedImage
                                             compressionQuality:compressionQuality];
    resultDictMutable[@"imagePath"] = imagePath;

    imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.fullSizeImage
                                   compressionQuality:compressionQuality];

    resultDictMutable[@"fullImagePath"] = imagePath;

    [self handleResult:resultDictMutable];
}


// MARK: - ALViewPluginCompositeDelegate

- (void)viewPluginComposite:(ALViewPluginComposite *)viewPluginComposite
         allResultsReceived:(NSArray<ALScanResult *> *)scanResults {
    // combine all into an array and create a string version of it.
    NSMutableDictionary *results = [NSMutableDictionary dictionaryWithCapacity:scanResults.count];
    CGFloat compressionQuality = self.quality / 100.0f;

    for (ALScanResult *scanResult in scanResults) {
        NSMutableDictionary *resultDictMutable = [NSMutableDictionary dictionaryWithDictionary:scanResult.resultDictionary];
        NSString *imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.croppedImage
                                                 compressionQuality:compressionQuality];
        resultDictMutable[@"imagePath"] = imagePath;
        imagePath = [ALPluginHelper saveImageToFileSystem:scanResult.fullSizeImage
                                       compressionQuality:compressionQuality];
        resultDictMutable[@"fullImagePath"] = imagePath;
        results[scanResult.pluginID] = resultDictMutable;
    }
    [self handleResult:results];
}

// MARK: - ALScanViewDelegate

- (void)scanView:(ALScanView *)scanView updatedCutoutWithPluginID:(NSString *)pluginID frame:(CGRect)frame {

    if (CGRectIsEmpty(frame)) {
        return;
    }

    CGFloat xOffset = self.uiConfig.labelXPositionOffset;
    CGFloat yOffset = self.uiConfig.labelYPositionOffset;

    // takes into account that frame reported for a cutout is in relation to
    // its scan view's coordinate system
    yOffset += [self.scanView convertRect:frame toView:self.scanView.superview].origin.y;

    self.labelHorizontalOffsetConstraint.constant = xOffset;

    self.labelVerticalOffsetConstraint.constant = yOffset;
}

- (void)scanView:(ALScanView *)scanView didReceiveNativeBarcodeResult:(ALScanResult *)scanResult {
    // for this implementation we just take the last detected (we can show a list of it)
    [self.detectedBarcodes removeAllObjects];
    [self.detectedBarcodes addObject:scanResult.resultDictionary];
}

// MARK: - Selector Actions

- (void)doneButtonPressed:(id)sender {
    [self.scanView.scanViewPlugin stop];

    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.callback(nil, @"Canceled");
    }];
}

- (void)segmentChange:(id)sender {
    NSString *viewConfigFile = self.uiConfig.segmentViewConfigs[((UISegmentedControl *)sender).selectedSegmentIndex];
    [self updateViewConfig:viewConfigFile];
}

// MARK: - Handle scan mode switching

- (NSObject<ALScanViewPluginBase> *)scanViewPluginFromFileName:(NSString *)filename error:(NSError **)error {
    NSObject<FlutterPluginRegistrar> *registrar = [AnylinePlugin sharedInstance].registrar;

    NSString *extension = filename.pathExtension;
    if (extension.length < 1) {
        extension = @"json";
    }

    NSString *resourcePath = [[registrar lookupKeyForAsset:filename] stringByDeletingPathExtension];

    // trying to directly access config by just appending filename to the main bundle path
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:resourcePath withExtension:extension];

    if (!fileURL) {
        // going to recursively search for the filename in the param
        // if the filename param includes a relative path, they are not going to be used here!

        NSMutableArray *potentialFilePaths = [NSMutableArray array];
        NSString *assetsRootPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[registrar lookupKeyForAsset:@""]];
        NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:assetsRootPath];
        NSString *filePath;

        // best-effort, potentially imprecise
        while ((filePath = [enumerator nextObject]) != nil) {
            if ([filePath.pathExtension isEqualToString:extension]) {
                NSString *name = filePath.lastPathComponent.stringByDeletingPathExtension;
                if ([name isEqualToString:[filename stringByDeletingPathExtension]]) {
                    [potentialFilePaths addObject:[assetsRootPath stringByAppendingPathComponent:filePath]];
                }
            }
        }
        if (potentialFilePaths.count > 0) {
            fileURL = [NSURL fileURLWithPath:potentialFilePaths[0]];
        }
    }

    if (!fileURL) {
        if (error) {
            NSString *errorMsg = [NSString stringWithFormat:@"Config file not found: %@", filename];
            *(error) = [NSError errorWithDomain:@"AnylineErrorDomain" code:1000 userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
        }
        return nil;
    }

    NSString *configStr = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:error];
    if (!configStr) {
        return nil;
    }

    NSDictionary *configDict = [configStr toJSONObject:error];
    if (!configDict) {
        return nil;
    }

    ALScanViewPlugin *newScanViewPlugin = [[ALScanViewPlugin alloc] initWithJSONDictionary:configDict error:error];
    if (!newScanViewPlugin) {
        return nil;
    }

    return newScanViewPlugin;
}

- (void)updateViewConfig:(NSString *)filename {

    NSError *error;
    ALScanViewPlugin *newScanViewPlugin = (ALScanViewPlugin *)[self scanViewPluginFromFileName:filename error:&error];
    if (!newScanViewPlugin) {
        [self showErrorAlertIfNeeded:error];
        return;
    }
    
    newScanViewPlugin.scanPlugin.delegate = self;

    BOOL success = [self.scanView setScanViewPlugin:newScanViewPlugin error:&error];
    if (!success) {
        [self showErrorAlertIfNeeded:error];
        return;
    }
    success = [[self.scanView scanViewPlugin] startWithError:&error];
    if (!success) {
        [self showErrorAlertIfNeeded:error];
        return;
    }
}

// Check whether the scan modes indicated in options > segmentConfig are valid.
// Otherwise, the segment control is not shown.
- (BOOL)segmentModesAreValid {
    if (self.uiConfig.segmentViewConfigs.count < 1) {
        return NO;
    }
    // easy question first: is there an identical number of segViewConfigs and segTitles?
    if (self.uiConfig.segmentViewConfigs.count != self.uiConfig.segmentTitles.count) {
        NSLog(@"Error: should have the same number of segment viewConfigs and segment titles!");
        return NO;
    }
    return YES;
}

// MARK: - Miscellaneous

- (BOOL)showErrorAlertIfNeeded:(NSError *)error {
    return [ALPluginHelper showErrorAlertIfNeeded:error pluginCallback:self.callback];
}

@end
