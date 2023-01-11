#import <Anyline/Anyline.h>
#import "AnylinePlugin.h"
#import "ALPluginHelper.h"

@implementation AnylinePlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                     methodChannelWithName:@"anyline_plugin"
                                     binaryMessenger:[registrar messenger]];
    AnylinePlugin *instance = [[AnylinePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"METHOD_GET_SDK_VERSION" isEqualToString:call.method]) {
        result([AnylineSDK versionNumber]);

    } else if ([@"METHOD_START_ANYLINE" isEqualToString:call.method]) {

        NSString *configJSONStr = call.arguments[@"EXTRA_CONFIG_JSON"];
        NSError *error;

        NSDictionary *dictConfig = [configJSONStr toJSONObject:&error];
        if (!dictConfig) {
            result(error.debugDescription);
            return;
        }

        [ALPluginHelper startScan:dictConfig finished:^(id  _Nonnull callbackObj, NSString * _Nonnull errorString) {

            NSString *resultStr;
            NSError *error;
            if (errorString) {
                resultStr = errorString;
            } else if ([callbackObj isKindOfClass:NSDictionary.class]) {
                resultStr = [(NSDictionary *)callbackObj toJSONStringPretty:YES error:&error];
                if (error) {
                    resultStr = error.debugDescription;
                }
            } else {
                resultStr = @"callback object should be of dictionary type";
            }
            result(resultStr);
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
