
#import "NativeViewContainer.h"
#import "NativeViewRegistry.h"
#import <UIKit/UIKit.h>

@implementation NativeViewContainer {
    UIView *_containerView;
}

// Scene-based hosts keep the window on the scene delegate, so delegate.window is nil there
+ (nullable UIWindow *)hostWindow {
    if (@available(iOS 13.0, *)) {
        UIWindow *fallback = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]] ||
                ![scene.session.role isEqualToString:UIWindowSceneSessionRoleApplication] ||
                ![scene.delegate conformsToProtocol:@protocol(UIWindowSceneDelegate)] ||
                ![scene.delegate respondsToSelector:@selector(window)]) {
                continue;
            }
            UIWindow *window = ((id<UIWindowSceneDelegate>)scene.delegate).window;
            if (!window) {
                continue;
            }
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                return window;
            }
            if (!fallback) {
                fallback = window;
            }
        }
        if (fallback) {
            return fallback;
        }
    }
    id<UIApplicationDelegate> appDelegate = UIApplication.sharedApplication.delegate;
    return [appDelegate respondsToSelector:@selector(window)] ? appDelegate.window : nil;
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

        UIViewController *rootVC = [NativeViewContainer hostWindow].rootViewController;
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
