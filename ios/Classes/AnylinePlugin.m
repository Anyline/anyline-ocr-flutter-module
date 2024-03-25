#import <Anyline/Anyline.h>
#import "AnylinePlugin.h"
#import "ALPluginHelper.h"

@implementation AnylinePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"anyline_plugin"
                                     binaryMessenger:[registrar messenger]];
    AnylinePlugin *instance = [AnylinePlugin sharedInstance];
    [registrar addMethodCallDelegate:instance channel:channel];
    instance.registrar = registrar;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"METHOD_GET_SDK_VERSION" isEqualToString:call.method]) {
        result([AnylineSDK versionNumber]);
    } else if ([@"METHOD_SET_CUSTOM_MODELS_PATH" isEqualToString:call.method]) {
        // iOS doesn't implement this call, but it needs to be present (MSDK-19)

    } else if ([@"METHOD_SET_VIEW_CONFIGS_PATH" isEqualToString:call.method]) {
        // iOS doesn't implement this call, but it needs to be present (MSDK-19)
    } else if ([@"METHOD_SET_LICENSE_KEY" isEqualToString:call.method]) {
        NSString *licenseKey = call.arguments[@"EXTRA_LICENSE_KEY"];
        NSError *error;

        ALCacheConfig *cacheConfig;
        if ([call.arguments[@"EXTRA_ENABLE_OFFLINE_CACHE"] boolValue] == true) {
            cacheConfig = [ALCacheConfig offlineLicenseCachingEnabled];
        }

        // wrapper information
        ALWrapperConfig *wrapperConfig = [ALWrapperConfig none];
        NSString *pluginVersion = call.arguments[@"EXTRA_PLUGIN_VERSION"];
        if (pluginVersion) {
            wrapperConfig = [ALWrapperConfig flutter:pluginVersion];
        }

        BOOL success = [AnylineSDK setupWithLicenseKey:licenseKey cacheConfig:cacheConfig wrapperConfig:wrapperConfig error:&error];
        if (!success) {
            result([FlutterError errorWithCode:@"AnylineLicenseException"
                                       message:error.localizedDescription
                                       details:nil]);
            return;
        }
        result(@(YES));

    } else if ([@"METHOD_START_ANYLINE" isEqualToString:call.method]) {

        NSString *configJSONStr = call.arguments[@"EXTRA_CONFIG_JSON"];
        NSError *error;

        NSDictionary *dictConfig = [configJSONStr toJSONObject:&error];
        if (!dictConfig) {
            result([FlutterError errorWithCode:@"AnylineConfigException"
                                       message:error.localizedDescription
                                       details:nil]);
            return;
        }
        [ALPluginHelper startScan:dictConfig finished:^(id  _Nonnull callbackObj, NSString * _Nonnull errorString) {
            NSString *resultStr;
            NSError *error;
            if (errorString) {
                resultStr = errorString;
            } else if ([NSJSONSerialization isValidJSONObject:callbackObj]) {
                resultStr = [(NSDictionary *)callbackObj toJSONStringPretty:YES error:&error];
                if (error) {
                    resultStr = error.debugDescription;
                }
            } else {
                resultStr = @"callback object should be of JSON type";
            }
            result(resultStr);
        }];
    } else if ([@"METHOD_GET_APPLICATION_CACHE_PATH" isEqualToString:call.method]) {
        result([ALPluginHelper applicationCachePath]);
    } else if ([@"METHOD_EXPORT_CACHED_EVENTS" isEqualToString:call.method]) {
        NSError *error;
        NSString *path = [AnylineSDK exportCachedEvents:&error];
        if (!path) {
            result([FlutterError errorWithCode:@"AnylineCacheException" message:error.localizedDescription details:nil]);
            return;
        }
        result(path);
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

@end
