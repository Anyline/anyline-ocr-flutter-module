#import <UIKit/UIKit.h>
#import "ALPluginHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALPluginScanViewController : UIViewController

@property (nonatomic, strong) NSString *cropAndTransformErrorMessage;

@property (nonatomic, assign) NSUInteger quality;

- (instancetype)initWithLicensekey:(NSString *)licenseKey
                     configuration:(NSDictionary *)config
                   uiConfiguration:(ALJSONUIConfiguration *)JSONUIConfig
           initializationParamsStr:(NSString *)initializationParamsStr
                          finished:(ALPluginCallback)callback;

@end

NS_ASSUME_NONNULL_END
