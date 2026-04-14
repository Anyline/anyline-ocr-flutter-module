#import <Flutter/Flutter.h>
#import <Anyline/Anyline.h>

@interface AnylineInfinityPlugin : NSObject<FlutterPlugin, ALWrapperSessionClientDelegate>

+ (instancetype _Nonnull)sharedInstance;

@end