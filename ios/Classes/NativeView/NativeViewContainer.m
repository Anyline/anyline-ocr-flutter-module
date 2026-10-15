
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
        _containerView.backgroundColor = [UIColor lightGrayColor];

        //NSString *containerId = args[@"id"];
        NSString *containerId = [NSString stringWithFormat:@"%lld", viewId];
        [[NativeViewRegistry shared] registerView:_containerView withId:containerId];
    }
    return self;
}

- (UIView *)view {
    return _containerView;
}

@end
