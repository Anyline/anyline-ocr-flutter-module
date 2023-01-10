#import <UIKit/UIKit.h>
#import "ALPluginHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALPluginScanViewController : UIViewController

@property (nonatomic, assign) BOOL nativeBarcodeEnabled;

@property (nonatomic, strong) NSString *cropAndTransformErrorMessage;

@property (nonatomic, assign) NSUInteger quality;

- (instancetype)initWithLicensekey:(NSString *)licensekey
                     configuration:(NSDictionary *)anylineConfig
                   uiConfiguration:(ALJSONUIConfiguration *)jsonUIConfig
                          finished:(ALPluginCallback)callback;

@end

NS_ASSUME_NONNULL_END
