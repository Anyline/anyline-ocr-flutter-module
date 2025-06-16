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

@property (nonatomic, strong) NSError *scanViewError;

@property (nonatomic, strong) NSString *initializationParamsStr;

@property (nonatomic, assign) UIInterfaceOrientation requiredOrientation;

@end


@implementation ALPluginScanViewController

- (void)dealloc {
    // NSLog(@"ACO dealloc ALPluginScanViewController");
}

- (instancetype)initWithLicensekey:(NSString *)licenseKey
                     configuration:(NSDictionary *)config
                   uiConfiguration:(ALJSONUIConfiguration *)JSONUIConfig
           initializationParamsStr:(NSString *)initializationParamsStr
                          finished:(ALPluginCallback)callback {
    
    if (self = [super init]) {
        _licenseKey = licenseKey;
        _callback = callback;
        _config = config;
        _uiConfig = JSONUIConfig;
        _initializationParamsStr = initializationParamsStr;
        
        self.quality = 100;
        self.cropAndTransformErrorMessage = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    ALScanViewInitializationParameters *initializationParams = nil;
    if(![self isStringEmpty:_initializationParamsStr]){
        initializationParams = [ALScanViewInitializationParameters withJSONString: _initializationParamsStr error:&error];
    }
    
    if ([self showErrorAlertIfNeeded:error]) {
        self.scanViewError = error;
        return;
    }

    // Set default orientation from config
    self.requiredOrientation = self.uiConfig.defaultOrientation;

    if (self.uiConfig.toolbarTitle) {
        //If toolbarTitle is defined, toolbar will be shown with back button and the text value of toolbarTitle.
        self.toolbar = [ALPluginHelper createToolbarForViewController:self config:self.uiConfig];
    }

    self.scanView = [ALScanViewFactory withJSONDictionary:self.config
                                     initializationParams:initializationParams
                                                 delegate:self
                                                    error:&error];
    
    if ([self showErrorAlertIfNeeded:error]) {
        self.scanViewError = error;
        return;
    }

    [self.view addSubview:self.scanView];
    
    self.scanView.translatesAutoresizingMaskIntoConstraints = false;
    if (self.toolbar) {
        // Update scanView top constraint to be below toolbar
        [self.scanView.topAnchor constraintEqualToAnchor:self.toolbar.bottomAnchor].active = YES;
    } else {
        [self.scanView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor].active = YES;
    }
    [self.scanView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.scanView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.scanView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    self.scanView.supportedNativeBarcodeFormats = self.uiConfig.nativeBarcodeFormats;
    self.scanView.delegate = self;
    self.detectedBarcodes = [NSMutableArray array];

    if (!self.uiConfig.toolbarTitle || self.uiConfig.shouldUseDoneButton) {
        //If neither toolbarTitle nor doneButtonConfig are defined, the default doneButton will be shown
        self.doneButton = [ALPluginHelper createButtonForViewController:self
                           config:self.uiConfig refView:self.scanView];
    }
    
    self.scannedLabel = [ALPluginHelper createLabelForView:self.view];
    
    [self configureLabel:self.scannedLabel config:self.uiConfig];
    
    [self configureSegmentControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.uiConfig.shouldUseButtonRotate) {
        [self setupFlipOrientationButton];
    }

    [self.scanView startCamera];

    [self setOrientation:self.requiredOrientation];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // avoid allowing the app to be put to sleep after a long period without touch events
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    NSError *error;
    if(!self.scanViewError){
        [self.scanView.viewPlugin startWithError:&error];
        [self showErrorAlertIfNeeded:error];
    }
    else{
        [self dismissViewControllerAnimated:YES completion:^{
            self.callback(nil, self.scanViewError);
        }];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidDisappear:animated];
}

- (void)flipOrientationPressed:(id)sender {
    // Toggle between portrait and landscape
    UIInterfaceOrientation newOrientation = (self.requiredOrientation == UIInterfaceOrientationPortrait) ?
        UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;

    self.requiredOrientation = newOrientation;

    [self setOrientation:newOrientation];
}

- (void)setOrientation:(UIInterfaceOrientation)orientation {
    // Store the desired orientation
    self.requiredOrientation = orientation;
    
    // Request the desired orientation using proper APIs
    if (@available(iOS 16.0, *)) {
        [self setNeedsUpdateOfSupportedInterfaceOrientations];
        UIWindowScene *windowScene = self.view.window.windowScene;
        if (windowScene) {
            UIWindowSceneGeometryPreferencesIOS *preferences = [[UIWindowSceneGeometryPreferencesIOS alloc]
                initWithInterfaceOrientations:(orientation == UIInterfaceOrientationLandscapeRight) ?
                    UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait];
            [windowScene requestGeometryUpdateWithPreferences:preferences errorHandler:^(NSError * _Nonnull error) {
                NSLog(@"Failed to update orientation: %@", error);
            }];
        }
    } else {
        // For older iOS versions
        UIDeviceOrientation deviceOrientation;
        
        // Convert interface orientation to device orientation
        switch (orientation) {
            case UIInterfaceOrientationLandscapeRight:
                deviceOrientation = UIDeviceOrientationLandscapeLeft;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                deviceOrientation = UIDeviceOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                break;
            case UIInterfaceOrientationPortrait:
            default:
                deviceOrientation = UIDeviceOrientationPortrait;
                break;
        }
        
        // Set the device orientation
        if ([[UIDevice currentDevice] orientation] != deviceOrientation) {
            [[UIDevice currentDevice] setValue:@(deviceOrientation) forKey:@"orientation"];
        }
        
        // Force update
        [UIViewController attemptRotationToDeviceOrientation];
    }

    // Update button image based on new orientation
    NSString *imageName = (orientation == UIInterfaceOrientationPortrait) ? @"rotate.right" : @"rotate.left";
    [self.flipOrientationButton setImage:[UIImage systemImageNamed:imageName] forState:UIControlStateNormal];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    // Only allow the specific orientation we want
    return (self.requiredOrientation == UIInterfaceOrientationLandscapeRight) ?
        UIInterfaceOrientationMaskLandscapeRight : UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.requiredOrientation;
}

- (void)setupFlipOrientationButton {
    UIButton *flipOrientationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (flipOrientationBtn) {
        [flipOrientationBtn addTarget:self
                                       action:@selector(flipOrientationPressed:)
                             forControlEvents:UIControlEventTouchUpInside];

        flipOrientationBtn.frame = CGRectMake(0, 0, 50, 50);
        UIImage *buttonImage = [UIImage systemImageNamed:@"rotate.right"];
        [flipOrientationBtn setImage:buttonImage forState:UIControlStateNormal];
        flipOrientationBtn.imageView.tintColor = UIColor.whiteColor;
        [flipOrientationBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
        flipOrientationBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        flipOrientationBtn.adjustsImageWhenDisabled = NO;

        [flipOrientationBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:flipOrientationBtn];
        flipOrientationBtn.layer.cornerRadius = 25;
        flipOrientationBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        
        // We add a default offset to ensure the behavior is similar to Android
        CGFloat buttonXPositionOffset = self.uiConfig.buttonRotateXPositionOffset;
        CGFloat buttonYPositionOffset = self.uiConfig.buttonRotateYPositionOffset;
        static const CGFloat kDefaultButtonEdgeInset = 10.0f;

        // Add constraints with 10-pixel offset from edges
        switch (self.uiConfig.buttonRotateXAlignment) {
            case ALButtonXAlignmentLeft:
                buttonXPositionOffset = buttonXPositionOffset + kDefaultButtonEdgeInset;
                break;
            case ALButtonXAlignmentRight:
                buttonXPositionOffset = buttonXPositionOffset - kDefaultButtonEdgeInset;
                break;
            case ALButtonXAlignmentCenter:
                break;
        }

        switch (self.uiConfig.buttonRotateYAlignment) {
            case ALButtonYAlignmentTop:
                buttonYPositionOffset = buttonYPositionOffset + kDefaultButtonEdgeInset;
                break;
            case ALButtonYAlignmentBottom:
                buttonYPositionOffset = buttonYPositionOffset - kDefaultButtonEdgeInset;
                break;
            case ALButtonYAlignmentCenter:
                break;
        }

        [ALPluginHelper updateButtonPosition:flipOrientationBtn
                                  xAlignment:self.uiConfig.buttonRotateXAlignment
                                  yAlignment:self.uiConfig.buttonRotateYAlignment
                             xPositionOffset:buttonXPositionOffset
                             yPositionOffset:buttonYPositionOffset
                               containerView:self.view
                                     refView:self.scanView];

        NSArray *flipSizeConstraints = @[[flipOrientationBtn.widthAnchor constraintEqualToConstant:50],
                                     [flipOrientationBtn.heightAnchor constraintEqualToConstant:50]];

        [self.view addConstraints:flipSizeConstraints];
        [NSLayoutConstraint activateConstraints:flipSizeConstraints];

        
        self.flipOrientationButton = flipOrientationBtn;
    }
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
    [self.segment.bottomAnchor constraintEqualToAnchor:self.scanView.safeAreaLayoutGuide.bottomAnchor
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
    NSObject<ALViewPluginBase> *viewPluginBase = self.scanView.viewPlugin;
    if ([viewPluginBase isKindOfClass:ALScanViewPlugin.class]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        ALScanViewPlugin *scanViewPlugin = (ALScanViewPlugin *)viewPluginBase;
        BOOL cancelOnResult = scanViewPlugin.scanPlugin.pluginConfig.cancelOnResult;
        if (cancelOnResult) {
            self.callback(resultDictionary, nil);
        }
    } else if ([viewPluginBase isKindOfClass:ALViewPluginComposite.class]) {
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
    [self.scanView.viewPlugin stop];
    
    __weak __block typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        weakSelf.callback(nil, [NSError errorWithDomain:@"ALFlutterDomain" code:-1 userInfo:@{@"Error reason": @"Canceled"}]);
    }];
}

- (void)segmentChange:(id)sender {
    NSString *viewConfigFile = self.uiConfig.segmentViewConfigs[((UISegmentedControl *)sender).selectedSegmentIndex];
    [self updateViewConfig:viewConfigFile];
}

// MARK: - Handle scan mode switching

- (ALScanViewConfig *)scanViewConfigFromFileName:(NSString *)filename error:(NSError **)error {
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
            *(error) = [NSError errorWithDomain:@"ALFlutterDomain" code:1000 userInfo:@{ NSLocalizedDescriptionKey: errorMsg }];
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
    
    ALScanViewConfig *newScanViewConfig = [[ALScanViewConfig alloc] initWithJSONDictionary:configDict error:error];
    if (!newScanViewConfig) {
        return nil;
    }
    
    return newScanViewConfig;
}

- (void)updateViewConfig:(NSString *)filename {
    
    NSError *error;
    ALScanViewConfig *newScanViewConfig = [self scanViewConfigFromFileName:filename error:&error];
    if (!newScanViewConfig) {
        if([self showErrorAlertIfNeeded:error]){
            [self dismissOnError: error];
        }
        return;
    }

    ALViewPluginConfig *newViewPluginConfig = newScanViewConfig.viewPluginConfig;
    if (!newViewPluginConfig) {
        if([self showErrorAlertIfNeeded:error]){
            [self dismissOnError: error];
        }
        return;
    }
    
    BOOL success = [self.scanView setViewPluginConfig:newViewPluginConfig error:&error];
    if (!success) {
        if([self showErrorAlertIfNeeded:error]){
            [self dismissOnError: error];
        }
        return;
    }
    ((ALScanViewPlugin *)self.scanView.viewPlugin).scanPlugin.delegate = self;
    success = [self.scanView.viewPlugin startWithError:&error];
    if (!success) {
        if([self showErrorAlertIfNeeded:error]){
            [self dismissOnError: error];
        }
        return;
    }

    _config = [newScanViewConfig.asJSONString toJSONObject:&error];
    
    NSDictionary *optionsDict = [_config objectForKey:@"options"];
    _uiConfig = [[ALJSONUIConfiguration alloc] initWithDictionary:optionsDict];
    
    if (_toolbar && _uiConfig.toolbarTitle) {
        if (_toolbar.items.count > 1) {
            UIBarButtonItem *barButtonItem = _toolbar.items[1];
            if (@available(iOS 13.0, *)) {
                // For iOS 13+, we need to update the custom button's title
                UIButton *customButton = (UIButton *)barButtonItem.customView;
                if ([customButton isKindOfClass:[UIButton class]]) {
                    [customButton setTitle:_uiConfig.toolbarTitle forState:UIControlStateNormal];
                }
            } else {
                // For pre-iOS 13, we can update the bar button item directly
                barButtonItem.title = [NSString stringWithFormat:@"← %@", _uiConfig.toolbarTitle];
            }
        }
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
    if (!error) {
        return NO;
    }
    
    return YES;
}

-(void)dismissOnError:(NSError *)error{
    [self dismissViewControllerAnimated:YES completion:^{
        self.callback(nil, error);
    }];
}

-(BOOL)isStringEmpty:(NSString *)str {
     if(str == nil || [str isKindOfClass:[NSNull class]] || str.length==0) {
            return YES;
       }
      return NO;
  }

@end
