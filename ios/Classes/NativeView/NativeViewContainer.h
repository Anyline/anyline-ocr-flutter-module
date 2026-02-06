
#import <Flutter/Flutter.h>

@interface NativeViewContainer : NSObject <FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
                 viewIdentifier:(int64_t)viewId
                      arguments:(id _Nullable)args;
@end
