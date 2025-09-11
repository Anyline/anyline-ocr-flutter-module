#import "AnylinePlugin.h"

// Static instance to retain the ALWrapperSessionProvider instance
static ALWrapperSessionProvider *_wrapperSessionProvider;

@interface AnylinePlugin ()

@property (nonatomic, strong) NSString *customModelsPath;
@property (nonatomic, strong) NSString *viewConfigsPath;

@property (nonatomic, strong) FlutterMethodChannel *channel;

@property (nonatomic, strong) FlutterResult initSdkMethodResult;
@property (nonatomic, strong) FlutterResult startScanMethodResult;
@property (nonatomic, strong) FlutterResult exportCachedEventsMethodResult;
@property (nonatomic, strong) FlutterResult reportCorrectedResultMethodResult;

@end

@implementation AnylinePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"anyline_plugin"
                                     binaryMessenger:[registrar messenger]];
    if (!_wrapperSessionProvider) {
        // Initialize the wrapperSessionProvider static variable
        _wrapperSessionProvider = [[ALWrapperSessionProvider alloc] init];
    }
    
    AnylinePlugin *instance = [AnylinePlugin sharedInstance];
    instance.channel = channel;
    
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.registrar = registrar;
}

-(NSString * _Nullable)getStringFromArgument:(id) argument {
    NSString *stringReturn;
    if (argument != nil && ![argument isKindOfClass:[NSNull class]]) {
        stringReturn = argument;
    }
    return stringReturn;
}

+ (NSString *)applicationCachePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"METHOD_GET_SDK_VERSION" isEqualToString:call.method]) {
        result([AnylineSDK versionNumber]);
    } else if ([@"METHOD_SETUP_WRAPPER_SESSION" isEqualToString:call.method]) {
        NSString *pluginVersion = call.arguments[@"EXTRA_PLUGIN_VERSION"];
        [self setupWrapperSessionWithPluginVersion:pluginVersion];
    } else if ([@"METHOD_SET_CUSTOM_MODELS_PATH" isEqualToString:call.method]) {
        _customModelsPath = call.arguments[@"EXTRA_CUSTOM_MODELS_PATH"];
    } else if ([@"METHOD_SET_VIEW_CONFIGS_PATH" isEqualToString:call.method]) {
        _viewConfigsPath = call.arguments[@"EXTRA_VIEW_CONFIGS_PATH"];
    } else if ([@"METHOD_SET_LICENSE_KEY" isEqualToString:call.method]) {
        _initSdkMethodResult = result;
        
        NSString *licenseKey = call.arguments[@"EXTRA_LICENSE_KEY"];
        BOOL enableOfflineCache = [call.arguments[@"EXTRA_ENABLE_OFFLINE_CACHE"] boolValue] == true;
        
        [self initSdkWithLicenseKey:licenseKey sdkAssetsFolder:self.customModelsPath enableOfflineCache:enableOfflineCache];
    } else if ([@"METHOD_START_ANYLINE" isEqualToString:call.method]) {
        _startScanMethodResult = result;

        [self requestScanStartWithScanViewConfigContent:[self getStringFromArgument:call.arguments[@"EXTRA_CONFIG_JSON"]]
                 scanViewInitializationParametersString:[self getStringFromArgument:call.arguments[@"EXTRA_INITIALIZATION_PARAMETERS"]]
                                     scanViewConfigPath:_viewConfigsPath
                               scanCallbackConfigString:[self getStringFromArgument:call.arguments[@"EXTRA_SCAN_CALLBACK_CONFIG"]]];
    } else if ([@"METHOD_STOP_ANYLINE" isEqualToString:call.method]) {
        [self tryStopScan:[self getStringFromArgument:call.arguments[@"EXTRA_STOP_CONFIG"]]];
    } else if ([@"METHOD_GET_APPLICATION_CACHE_PATH" isEqualToString:call.method]) {
        result([AnylinePlugin applicationCachePath]);
    } else if ([@"METHOD_EXPORT_CACHED_EVENTS" isEqualToString:call.method]) {
        _exportCachedEventsMethodResult = result;
        [self exportCachedEvents];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (instancetype)sharedInstance {
    static AnylinePlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)sendEvent:(NSString *)eventName
           params:(id _Nullable) params {
    if (_channel && eventName) {
        [_channel invokeMethod:eventName arguments:params];
    }
}

-(NSString *)bundleRootPath {
    NSString *rootPath = [[NSBundle mainBundle] bundlePath];
    return rootPath;
}

-(NSString *)bundlePathFromScanViewConfigPath:(NSString * _Nullable)scanViewConfigPath {
    //get root folder (ends with ...Runner.app)
    NSString *absoluteScanViewConfigPath = [self bundleRootPath];

    NSString *assetPath = [_registrar lookupKeyForAsset:@""];
    if (assetPath) {
        //append framework (Frameworks/App.framework/flutter_assets)
        absoluteScanViewConfigPath = [absoluteScanViewConfigPath stringByAppendingPathComponent:assetPath];

        //the following condition keeps Android and iOS compatible)
        if (scanViewConfigPath) {
            //when scanViewConfigPath was specified then it must come together with the flutter_assets
            //remove flutter_assets from absoluteScanViewConfigPath
            absoluteScanViewConfigPath = [absoluteScanViewConfigPath stringByDeletingLastPathComponent];
            //append scanViewConfigPath
            absoluteScanViewConfigPath = [absoluteScanViewConfigPath stringByAppendingPathComponent:scanViewConfigPath];
        }
    }
    return absoluteScanViewConfigPath;
}

- (void)setupWrapperSessionWithPluginVersion:(NSString *)pluginVersion {
    // Setup wrapper session with this view controller as delegate
    ALWrapperConfig *wrapperConfig = [ALWrapperConfig flutter:pluginVersion];
    [ALWrapperSessionProvider setupWrapperSessionWithWrapperInfo:wrapperConfig
                                            wrapperSessionClient:self];
}


- (void)initSdkWithLicenseKey:(NSString *)sdkLicenseKey
              sdkAssetsFolder: (NSString *)sdkAssetsFolder
           enableOfflineCache: (BOOL)enableOfflineCache {
    NSDictionary *wrapperSessionSdkInitializationRequestJson = [ALLegacyPluginHelper
            sdkInitializationRequestJsonWithLicenseKey:sdkLicenseKey
                                    enableOfflineCache:enableOfflineCache
                                       assetPathPrefix:sdkAssetsFolder];

    [ALWrapperSessionProvider
            requestSdkInitializationWithInitializationRequestParamsString:[wrapperSessionSdkInitializationRequestJson asJSONString]];
}

- (void)requestScanStartWithScanViewConfigContent:(NSString *)scanViewConfigContent
           scanViewInitializationParametersString:(NSString * _Nullable)scanViewInitializationParametersString
                               scanViewConfigPath:(NSString * _Nullable)scanViewConfigPath
                         scanCallbackConfigString:(NSString * _Nullable)scanCallbackConfigString {
    NSError *error;
    BOOL shouldReturnImages = true;
    
    ALWrapperSessionScanStartRequest *wrapperSessionScanStartRequest = [ALLegacyPluginHelper
                                        scanStartRequestWithScanViewConfigContentString:scanViewConfigContent
                                                 scanViewInitializationParametersString:scanViewInitializationParametersString
                                                                     scanViewConfigPath:[self bundlePathFromScanViewConfigPath:scanViewConfigPath]
                                                         scanResultCallbackConfigString:scanCallbackConfigString
                                                                     shouldReturnImages:shouldReturnImages
                                                                                  error:&error];
    if (error) {
        if (_startScanMethodResult) {
            _startScanMethodResult([FlutterError errorWithCode:@"AnylineConfigException"
                                       message:error.localizedDescription
                                       details:error.userInfo]);
        }
    } else {
        NSDictionary *wrapperSessionScanStartRequestDict = [wrapperSessionScanStartRequest toJSONDictionary];
        [ALWrapperSessionProvider requestScanStartWithScanStartRequestParamsString:[wrapperSessionScanStartRequestDict asJSONString]];
    }
}

- (void)tryStopScan:(NSString * _Nullable)scanStopRequestParams {
    [ALWrapperSessionProvider requestScanStopWithScanStopRequestParamsString:scanStopRequestParams];
}

-(void)exportCachedEvents {
    [ALWrapperSessionProvider requestExportCachedEvents];
}

#pragma mark - ALWrapperSessionClientDelegate

- (nullable UIViewController *)getTopViewController {
    return nil;
}

- (void)onSdkInitializationResponse:(nonnull ALWrapperSessionSDKInitializationResponse *)initializationResponse {
    if (_initSdkMethodResult) {
        if (initializationResponse.initialized) {
            _initSdkMethodResult(@(YES));
        } else {
            _initSdkMethodResult([FlutterError errorWithCode:@"AnylineLicenseException"
                                       message:[[initializationResponse toJSONDictionary] asJSONString]
                                       details:nil]);
        }
    }
}

- (void)onScanResults:(nonnull ALWrapperSessionScanResultsResponse *)scanResultsResponse {
    ALWrapperSessionScanResultConfig *scanResultConfig = scanResultsResponse.scanResultConfig;
    NSArray<ALExportedScanResult *> *exportedScanResultsArray =
            (NSArray<ALExportedScanResult *> * _Nonnull) scanResultsResponse.exportedScanResults;
    ALWrapperSessionScanResultExtraInfo *scanResultExtraInfo =
            (ALWrapperSessionScanResultExtraInfo * _Nonnull) scanResultsResponse.scanResultExtraInfo;
    ALViewPluginType *viewPluginType = (ALViewPluginType * _Nonnull) scanResultExtraInfo.viewPluginType;

    NSError *error;
    NSString *originalResultsWithImagePathString = [ALLegacyPluginHelper scanResultsWithImagePathFromExportedScanResults:exportedScanResultsArray
                                                                                                          viewPluginType:viewPluginType
                                                                                                                   error:&error];
    
    if (scanResultConfig.callbackConfig && scanResultConfig.callbackConfig.onResultEventName) {
        [self sendEvent:scanResultConfig.callbackConfig.onResultEventName params:originalResultsWithImagePathString];
    } else {
        /*
         this implementation keeps the legacy behaviour of the plugin,
         dispatching the results to the startScanMethodResult when a
         onResultEventName was not provided on the callbackConfig
        */
        NSString *resultsWithImagePathString;
        if (viewPluginType == ALViewPluginType.viewPluginComposite) {
            NSData *jsonData = [originalResultsWithImagePathString dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *jsonResultArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];

            NSMutableDictionary *jsonResultObject = [NSMutableDictionary dictionary];
            for (NSDictionary *scanResultJson in jsonResultArray) {
                NSString *pluginId = scanResultJson[@"pluginID"];
                if (pluginId) {
                    jsonResultObject[pluginId] = scanResultJson;
                }
            }
            
            NSData *resultData = [NSJSONSerialization dataWithJSONObject:jsonResultObject options:0 error:&error];
            if (resultData) {
                resultsWithImagePathString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
            }
        } else {
            resultsWithImagePathString = originalResultsWithImagePathString;
        }
        _startScanMethodResult(resultsWithImagePathString);
    }
}

- (void)onScanResponse:(nonnull ALWrapperSessionScanResponse *)scanResponse {
    if (scanResponse.status == ALWrapperSessionScanResponseStatus.scanSucceeded) {
        ALWrapperSessionScanResultConfig *scanResultConfig = scanResponse.scanResultConfig;
        if (scanResultConfig.callbackConfig && scanResultConfig.callbackConfig.onResultEventName) {
            _startScanMethodResult(@"");
        }
    } else if (scanResponse.status == ALWrapperSessionScanResponseStatus.scanFailed) {
        _startScanMethodResult([FlutterError errorWithCode:@"AnylineConfigException"
                                                   message:scanResponse.failInfo.lastError
                                                   details:nil]);
    } else if (scanResponse.status == ALWrapperSessionScanResponseStatus.scanAborted) {
        _startScanMethodResult(@"Canceled");
    }
}

- (void)onUIElementClicked:(nonnull ALWrapperSessionScanResultConfig *)scanResultConfig
        uiFeedbackElementConfig:(nonnull ALUIFeedbackElementConfig *)uiFeedbackElementConfig {
    if (scanResultConfig.callbackConfig && scanResultConfig.callbackConfig.onUIElementClickedEventName) {
        [self sendEvent:scanResultConfig.callbackConfig.onUIElementClickedEventName
                 params:uiFeedbackElementConfig];
    }
}

- (void)onUCRReportResponse:(nonnull ALWrapperSessionUCRReportResponse *)ucrReportResponse {
    if (_reportCorrectedResultMethodResult) {
        if (ucrReportResponse.status == ALWrapperSessionUCRReportResponseStatus.ucrReportSucceeded) {
            ALWrapperSessionUCRReportResponseSucceed *ucrReportSucceed = ucrReportResponse.succeedInfo;
            _reportCorrectedResultMethodResult(ucrReportSucceed.message);
        } else {
            ALWrapperSessionUCRReportResponseFail *ucrReportFail = ucrReportResponse.failInfo;
            _reportCorrectedResultMethodResult([FlutterError errorWithCode:@"AnylineUCRException" message:ucrReportFail.lastError details:nil]);
        }
    }
}

- (void)onExportCachedEventsResponse:(nonnull ALWrapperSessionExportCachedEventsResponse *)exportCachedEventsResponse {
    if (_exportCachedEventsMethodResult) {
        if (exportCachedEventsResponse.status == ALWrapperSessionExportCachedEventsResponseStatus.exportSucceeded) {
            ALWrapperSessionExportCachedEventsResponseSucceed *exportCachedEventsSucceed = exportCachedEventsResponse.succeedInfo;
            _exportCachedEventsMethodResult(exportCachedEventsSucceed.exportedFile);
        } else {
            ALWrapperSessionExportCachedEventsResponseFail *exportCachedEventsFail = exportCachedEventsResponse.failInfo;
            _exportCachedEventsMethodResult([FlutterError errorWithCode:@"AnylineCacheException" message:exportCachedEventsFail.lastError details:nil]);
        }
    }
}

@end
