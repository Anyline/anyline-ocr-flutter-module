
#import "NativeViewContainer.h"
#import "NativeViewRegistry.h"
#import <UIKit/UIKit.h>

@implementation NativeViewContainer {
    UIView *_containerView;
}

- (instancetype)initWithFrame:(CGRect)frame
                 viewIdentifier:(int64_t)viewId
                      arguments:(id _Nullable)args {
    self = [super init];
    if (self) {
        _containerView = [[UIView alloc] initWithFrame:frame];

        //NSString *containerId = args[@"id"];
        NSString *containerId = [NSString stringWithFormat:@"%lld", viewId];
        [[NativeViewRegistry shared] registerView:_containerView withId:containerId];

        UIViewController *nativeVC = [[UIViewController alloc] init];
        nativeVC.view.backgroundColor = [UIColor lightGrayColor];
        nativeVC.view.frame = _containerView.bounds;

        UIViewController *rootVC = UIApplication.sharedApplication.delegate.window.rootViewController;
        [rootVC addChildViewController:nativeVC];
        [_containerView addSubview:nativeVC.view];
        [nativeVC didMoveToParentViewController:rootVC];
    }
    return self;
}

- (UIView *)view {
    return _containerView;
}

@end
