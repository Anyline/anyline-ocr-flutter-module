#import "AnylinePlugin.h"
#import <Anyline/Anyline.h>

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
      id config = call.arguments[@"EXTRA_CONFIG_JSON"];
      //[self scanAnyline:];
  } else {
      result(FlutterMethodNotImplemented);
  }
}



@end
