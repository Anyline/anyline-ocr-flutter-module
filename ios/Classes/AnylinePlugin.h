#import <Flutter/Flutter.h>

@interface AnylinePlugin : NSObject<FlutterPlugin>

@property (nonatomic, strong, nullable) NSObject<FlutterPluginRegistrar> *registrar;

+ (instancetype _Nonnull)sharedInstance;

@end
