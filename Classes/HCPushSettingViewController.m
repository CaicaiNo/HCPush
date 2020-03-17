//
//  HCPushSettingViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCPushSettingViewController.h"
#import <objc/runtime.h>

@interface HCPushSettingViewController ()

@end

@implementation HCPushSettingViewController {
    BOOL __viewDidLoad;
}

- (instancetype)initWithContentController:(UIViewController *)controller {
    if (self = [super init]) {
        [self setup];
        [self setPushChildViewController:controller];
    }
    return self;
}

+ (instancetype)settingControllerWithContentController:(UIViewController *)controller {
    return [[self alloc] initWithContentController:controller];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateChildViewConstraits];
    __viewDidLoad = YES;
}

- (void)updateChildViewConstraits {
    UIView *childView = self.pushChildViewController.view;
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    childView.frame = self.hcContentView.bounds;
    [self.hcContentView addSubview:childView];
    ///must add to hcContentView, not self.view
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)setPushChildViewController:(UIViewController * _Nonnull)pushChildViewController {
    if (_pushChildViewController) {
        [_pushChildViewController.view removeFromSuperview];
    }
    _pushChildViewController = pushChildViewController;
    _pushChildViewController.HCParentController = self;
    if (__viewDidLoad) {
        [self updateChildViewConstraits];
    }
}

- (void)setup {
    __viewDidLoad = NO;
}

#pragma mark - lift cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_viewWillShowHandler) {
        _viewWillShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_viewDidShowHandler) {
        _viewDidShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_viewWillHideHandler) {
        _viewWillHideHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_viewDidHideHandler) {
        _viewDidHideHandler(self.pushChildViewController.view);
    }
}

//- (void)dealloc {
//#if DEBUG
//    NSLog(@"HCPushSettingViewController dealloc");
//#endif
//}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    if (_pushChildViewController) {
        return [_pushChildViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (_pushChildViewController) {
        return [_pushChildViewController preferredInterfaceOrientationForPresentation];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_pushChildViewController) {
        return [_pushChildViewController supportedInterfaceOrientations];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@implementation HCProxy
- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}
+ (instancetype)proxyWithTarget:(id)target {
    return [[HCProxy alloc] initWithTarget:target];
}
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}
- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}
- (NSUInteger)hash {
    return [_target hash];
}
- (Class)superclass {
    return [_target superclass];
}
- (Class)class {
    return [_target class];
}
- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}
- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}
- (BOOL)isProxy {
    return YES;
}
- (NSString *)description {
    return [_target description];
}
- (NSString *)debugDescription {
    return [_target debugDescription];
}
@end

@implementation UIViewController (HCPush)

- (HCPushSettingViewController*)HCParentController {
    HCProxy *proxy = objc_getAssociatedObject(self, _cmd);
    return (HCPushSettingViewController*)proxy;
}

- (void)setHCParentController:(HCPushSettingViewController*)parentController {
    HCProxy *proxy = [HCProxy proxyWithTarget:parentController];
    objc_setAssociatedObject(self, @selector(HCParentController), proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
