//
//  ALPluginScanViewController.h
//  Anyline React-Native Example
//
//  Created by Daniel Albertini on 30.10.18.
//

#import <UIKit/UIKit.h>
#import "ALJsonUIConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALPluginScanViewController : UIViewController

typedef void (^ALPluginCallback)(id callbackObj, NSString *errorString);

@property (nonatomic, assign) BOOL nativeBarcodeEnabled;

@property (nonatomic, strong) NSString *cropAndTransformErrorMessage;

@property (nonatomic, assign) NSUInteger quality;

- (instancetype)initWithLicensekey:(NSString*)licensekey
                     configuration:(NSDictionary *)anylineConfig
                   uiConfiguration:(ALJsonUIConfiguration*)jsonUIConfig
                          finished:(ALPluginCallback)callback;

@end

NS_ASSUME_NONNULL_END
