#import <UIKit/UIKit.h>
#import "ALJsonUIConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALPluginScanViewController : UIViewController

typedef void (^ALPluginCallback)(id _Nullable callbackObj, NSString * _Nullable errorString);

@property (nonatomic, assign) BOOL nativeBarcodeEnabled;

@property (nonatomic, strong) NSString *cropAndTransformErrorMessage;

@property (nonatomic, assign) NSUInteger quality;

- (instancetype)initWithLicensekey:(NSString *)licensekey
                     configuration:(NSDictionary *)anylineConfig
                   uiConfiguration:(ALJsonUIConfiguration *)jsonUIConfig
                          finished:(ALPluginCallback)callback;

@end

NS_ASSUME_NONNULL_END
