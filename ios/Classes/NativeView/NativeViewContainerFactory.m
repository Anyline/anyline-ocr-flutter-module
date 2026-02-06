
#import "NativeViewContainerFactory.h"
#import "NativeViewContainer.h"

@implementation NativeViewContainerFactory

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame
                                    viewIdentifier:(int64_t)viewId
                                         arguments:(id _Nullable)args {
    return [[NativeViewContainer alloc] initWithFrame:frame viewIdentifier:viewId arguments:args];
}

@end
