#import <Flutter/Flutter.h>
#import <Anyline/Anyline.h>

__attribute__((deprecated("Use AnylineInfinityPlugin instead.")))
@interface AnylinePlugin : NSObject<FlutterPlugin, ALWrapperSessionClientDelegate>

@property (nonatomic, strong, nullable) NSObject<FlutterPluginRegistrar> *registrar;

+ (instancetype _Nonnull)sharedInstance;

@end
