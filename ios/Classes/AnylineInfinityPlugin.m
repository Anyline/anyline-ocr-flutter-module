#import "AnylineInfinityPlugin.h"
#import "NativeView/NativeViewRegistry.h"

// Static instance to retain the ALWrapperSessionProvider reference.
static ALWrapperSessionProvider *_infinityWrapperSessionProvider;

@interface AnylineInfinityPlugin ()

@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;

@property (nonatomic, strong) FlutterResult initSdkResult;
@property (nonatomic, strong) FlutterResult scanStartResult;
@property (nonatomic, strong) FlutterResult ucrReportResult;
@property (nonatomic, strong) FlutterResult exportCachedEventsResult;

@end

static NSString * const kChannelName = @"anyline_infinity_plugin";

static NSString * const kMethodSetupWrapperSession = @"INFINITY_SETUP_WRAPPER_SESSION";
static NSString * const kMethodRequestSdkInitialization = @"INFINITY_REQUEST_SDK_INITIALIZATION";
static NSString * const kMethodRequestScanStart = @"INFINITY_REQUEST_SCAN_START";
static NSString * const kMethodRequestScanSwitchWithScanStartRequestParams = @"INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_START_REQUEST_PARAMS";
static NSString * const kMethodRequestScanSwitchWithScanViewConfigContentString = @"INFINITY_REQUEST_SCAN_SWITCH_WITH_SCAN_VIEW_CONFIG_CONTENT_STRING";
static NSString * const kMethodRequestScanStop = @"INFINITY_REQUEST_SCAN_STOP";
static NSString * const kMethodRequestUcrReport = @"INFINITY_REQUEST_UCR_REPORT";
static NSString * const kMethodRequestExportCachedEvents = @"INFINITY_REQUEST_EXPORT_CACHED_EVENTS";
static NSString * const kMethodGetSDKVersion = @"INFINITY_GET_SDK_VERSION";

static NSString * const kEventOnScanResults = @"INFINITY_ON_SCAN_RESULTS";
static NSString * const kEventOnUiElementClicked = @"INFINITY_ON_UI_ELEMENT_CLICKED";

static NSString * const kExtraPluginVersion = @"EXTRA_PLUGIN_VERSION";
static NSString * const kExtraRequest = @"request";

@implementation AnylineInfinityPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:kChannelName
                                     binaryMessenger:[registrar messenger]];
    if (!_infinityWrapperSessionProvider) {
        _infinityWrapperSessionProvider = [[ALWrapperSessionProvider alloc] init];
    }

    AnylineInfinityPlugin *instance = [AnylineInfinityPlugin sharedInstance];
    instance.channel = channel;
    instance.registrar = registrar;

    [registrar addMethodCallDelegate:instance channel:channel];
}

+ (instancetype)sharedInstance {
    static AnylineInfinityPlugin *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([kMethodSetupWrapperSession isEqualToString:call.method]) {
        NSString *pluginVersion = call.arguments[kExtraPluginVersion];
        [self setupWrapperSessionWithPluginVersion:pluginVersion];
    } else if ([kMethodRequestSdkInitialization isEqualToString:call.method]) {
        _initSdkResult = result;
        [ALWrapperSessionProvider
            requestSdkInitializationWithInitializationRequestParamsString:call.arguments[kExtraRequest]];
    } else if ([kMethodRequestScanStart isEqualToString:call.method]) {
        _scanStartResult = result;
        [ALWrapperSessionProvider
            requestScanStartWithScanStartRequestParamsString:[self resolvedScanStartRequestJsonString:call.arguments[kExtraRequest]]];
    } else if ([kMethodRequestScanSwitchWithScanStartRequestParams isEqualToString:call.method]) {
        [ALWrapperSessionProvider requestScanSwitchWithScanStartRequestParamsString:[self resolvedScanStartRequestJsonString:call.arguments[kExtraRequest]]];
    } else if ([kMethodRequestScanSwitchWithScanViewConfigContentString isEqualToString:call.method]) {
        [ALWrapperSessionProvider
            requestScanSwitchWithScanViewConfigContentString:call.arguments[kExtraRequest]];
    } else if ([kMethodRequestScanStop isEqualToString:call.method]) {
        [ALWrapperSessionProvider
            requestScanStopWithScanStopRequestParamsString:call.arguments[kExtraRequest]];
    } else if ([kMethodRequestUcrReport isEqualToString:call.method]) {
        _ucrReportResult = result;
        [ALWrapperSessionProvider
            requestUCRReportWithWrapperSessionUCRReportRequestString:call.arguments[kExtraRequest]];
    } else if ([kMethodRequestExportCachedEvents isEqualToString:call.method]) {
        _exportCachedEventsResult = result;
        [ALWrapperSessionProvider requestExportCachedEvents];
    } else if ([kMethodGetSDKVersion isEqualToString:call.method]) {
        result([AnylineSDK versionNumber]);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSString *)bundlePathFromScanViewConfigPath:(NSString * _Nullable)scanViewConfigPath {
    // Guard against NSNull from JSON deserialization when the field is absent
    if ([scanViewConfigPath isKindOfClass:[NSNull class]]) scanViewConfigPath = nil;
    NSString *absolutePath = [[NSBundle mainBundle] bundlePath];
    NSString *assetPath = [self.registrar lookupKeyForAsset:@""];
    if (assetPath) {
        absolutePath = [absolutePath stringByAppendingPathComponent:assetPath];
        if (scanViewConfigPath) {
            // scanViewConfigPath is e.g. "flutter_assets/config/infinity" — strip the
            // leading "flutter_assets" component (already included via assetPath) then append.
            absolutePath = [absolutePath stringByDeletingLastPathComponent];
            absolutePath = [absolutePath stringByAppendingPathComponent:scanViewConfigPath];
        }
    }
    return absolutePath;
}

- (NSString *)resolvedScanStartRequestJsonString:(NSString *)requestJsonString {
    if (!requestJsonString) return requestJsonString;
    NSData *jsonData = [requestJsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *requestDict = [[NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil] mutableCopy];
    if (!requestDict) return requestJsonString;
    NSString *scanViewConfigPath = requestDict[@"scanViewConfigPath"];
    requestDict[@"scanViewConfigPath"] = [self bundlePathFromScanViewConfigPath:scanViewConfigPath];
    NSData *fixedData = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:nil];
    return fixedData ? [[NSString alloc] initWithData:fixedData encoding:NSUTF8StringEncoding] : requestJsonString;
}

- (void)setupWrapperSessionWithPluginVersion:(NSString *)pluginVersion {
    ALWrapperConfig *wrapperConfig = [ALWrapperConfig flutter:pluginVersion codename:ALWrapperCodenameInfinity];
    [ALWrapperSessionProvider setupWrapperSessionWithWrapperInfo:wrapperConfig
                                            wrapperSessionClient:self];
}

#pragma mark - ALWrapperSessionClientDelegate

- (nullable UIViewController *)getTopViewController {
    return nil;
}

- (nullable UIView *)getContainerView {
    return [[NativeViewRegistry shared] getLastOrNull];
}

- (void)onSdkInitializationResponse:(nonnull ALWrapperSessionSDKInitializationResponse *)initializationResponse {
    if (_initSdkResult) {
        NSDictionary *dict = [initializationResponse toJSONDictionary];
        _initSdkResult([dict asJSONString]);
        _initSdkResult = nil;
    }
}

- (void)onScanResults:(nonnull ALWrapperSessionScanResultsResponse *)scanResultsResponse {
    NSArray<ALExportedScanResult *> *results = (NSArray<ALExportedScanResult *> *)scanResultsResponse.exportedScanResults;
    NSMutableArray<NSDictionary *> *resultDicts = [NSMutableArray array];
    for (ALExportedScanResult *result in results) {
        [resultDicts addObject:[result toJSONDictionary]];
    }
    NSMutableDictionary *dict = [[scanResultsResponse toJSONDictionary] mutableCopy];
    dict[@"exportedScanResults"] = resultDicts;
    [_channel invokeMethod:kEventOnScanResults arguments:[dict asJSONString]];
}

- (void)onScanResponse:(nonnull ALWrapperSessionScanResponse *)scanResponse {
    if (_scanStartResult) {
        NSDictionary *dict = [scanResponse toJSONDictionary];
        _scanStartResult([dict asJSONString]);
        _scanStartResult = nil;
    }
}

- (void)onUIElementClicked:(nonnull ALWrapperSessionScanResultConfig *)scanResultConfig
    uiFeedbackElementConfig:(nonnull ALUIFeedbackElementConfig *)uiFeedbackElementConfig {
    NSDictionary *dict = [uiFeedbackElementConfig performSelector:@selector(JSONDictionary)];
    [_channel invokeMethod:kEventOnUiElementClicked arguments:[dict asJSONString]];
}

- (void)onUCRReportResponse:(nonnull ALWrapperSessionUCRReportResponse *)ucrReportResponse {
    if (_ucrReportResult) {
        NSDictionary *dict = [ucrReportResponse toJSONDictionary];
        _ucrReportResult([dict asJSONString]);
        _ucrReportResult = nil;
    }
}

- (void)onExportCachedEventsResponse:(nonnull ALWrapperSessionExportCachedEventsResponse *)exportCachedEventsResponse {
    if (_exportCachedEventsResult) {
        NSDictionary *dict = [exportCachedEventsResponse toJSONDictionary];
        _exportCachedEventsResult([dict asJSONString]);
        _exportCachedEventsResult = nil;
    }
}

@end
