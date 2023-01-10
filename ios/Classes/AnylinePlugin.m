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
            if (errorString) {
                result(errorString);
                return;
            }
            NSError *error = nil;

            if (![callbackObj isKindOfClass:NSDictionary.class]) {
                result(@"cannot convert result string to JSON");
                return;
            }

            NSDictionary *resultDict = (NSDictionary *)callbackObj;
            NSString *resultStr = [resultDict toJSONStringPretty:YES error:&error];

            if (error) {
                result(error.debugDescription);
                return;
            }

            result(resultStr);
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}



@end
