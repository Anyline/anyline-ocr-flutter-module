#import "ALJSONUIConfiguration.h"
#import "ALRoundedView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ALPluginCallback)(id _Nullable callbackObj, NSString * _Nullable errorString);


@interface ALPluginHelper : NSObject

+ (void)startScan:(NSDictionary *)config finished:(ALPluginCallback)callback;

+ (NSString *)saveImageToFileSystem:(UIImage *)image;

+ (NSString *)saveImageToFileSystem:(UIImage *)image
                 compressionQuality:(CGFloat)compressionQuality;

+ (UILabel *)createLabelForView:(UIView *)view;

+ (UIButton *)createButtonForViewController:(UIViewController *)viewController
                                     config:(ALJSONUIConfiguration *)config;

+ (ALRoundedView *)createRoundedViewForViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
