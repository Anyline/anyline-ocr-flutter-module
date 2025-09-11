#import <Flutter/Flutter.h>
#import <Anyline/Anyline.h>

@interface AnylinePlugin : NSObject<FlutterPlugin, ALWrapperSessionClientDelegate>

@property (nonatomic, strong, nullable) NSObject<FlutterPluginRegistrar> *registrar;

+ (instancetype _Nonnull)sharedInstance;

@end
