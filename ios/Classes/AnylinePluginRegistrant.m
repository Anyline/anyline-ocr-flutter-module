#import "AnylinePluginRegistrant.h"
#import "AnylinePlugin.h"
#import "AnylineInfinityPlugin.h"

/**
 * Entry point registered by Flutter's plugin system.
 *
 * Registers all Anyline Flutter plugins so each handles its own MethodChannel
 * independently. Adding or removing a plugin here has no effect on the others.
 */
@implementation AnylinePluginRegistrant

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [AnylinePlugin registerWithRegistrar:registrar];
    [AnylineInfinityPlugin registerWithRegistrar:registrar];
}

@end