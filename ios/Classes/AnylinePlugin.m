#import "AnylinePlugin.h"
#import <Anyline/Anyline.h>
#import "ALPluginHelper.h"

@implementation AnylinePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"anyline_plugin"
            binaryMessenger:[registrar messenger]];
  AnylinePlugin* instance = [[AnylinePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"METHOD_GET_SDK_VERSION" isEqualToString:call.method]) {
      result(ALCoreController.versionNumber);
  } else if ([@"METHOD_START_ANYLINE" isEqualToString:call.method]) {
      NSString *config = call.arguments[@"EXTRA_CONFIG_JSON"];
      NSError *error = nil;
      NSDictionary *dictConfig = [NSJSONSerialization JSONObjectWithData:[config dataUsingEncoding:NSUTF8StringEncoding]
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error];
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
          NSData *jsonResultData = [NSJSONSerialization dataWithJSONObject:callbackObj
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:&error];
          if (!jsonResultData) {
              result(error.debugDescription);
              return;
          }
          NSString* jsonResultString = [[NSString alloc] initWithData:jsonResultData
                                                             encoding:NSUTF8StringEncoding];
          result(jsonResultString);
      }];
  } else {
      result(FlutterMethodNotImplemented);
  }
}



@end
