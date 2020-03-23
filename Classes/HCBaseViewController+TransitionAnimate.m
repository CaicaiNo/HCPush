//
//  HCBaseViewController+TransitionAnimate.m
//  HCBaseViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//  https://github.com/haocaihaocai/HCPushSettingViewController.git

#import "HCBaseViewController.h"
#import "HCBaseAnimation.h"
#import "HCPushAnimation.h"
#import "HCBaseFadeAnimation.h"
#import "HCBaseDropDownAnimation.h"
#import "HCBaseScaleFadeAnimation.h"

@implementation HCBaseViewController (TransitionAnimate)

#pragma mark - UIViewControllerTransitioningDelegate

static id static_ret = nil;

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    
    SEL selector = @selector(alertAnimationIsPresenting:);
    if (self.transitionAnimationClass && [self.transitionAnimationClass respondsToSelector:selector]) {
        NSMethodSignature* methodSig = [self.transitionAnimationClass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        BOOL ispresenting = YES;
        [invocation setArgument:&ispresenting atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:self.transitionAnimationClass];
        [invocation invoke];
        void* ret = nil;
        [invocation getReturnValue:&ret];
        return (__bridge id)ret;
    }else {
        return nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    SEL selector = @selector(alertAnimationIsPresenting:);
    if (self.transitionAnimationClass && [self.transitionAnimationClass respondsToSelector:selector]) {
        NSMethodSignature* methodSig = [self.transitionAnimationClass methodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        BOOL ispresenting = NO;
        [invocation setArgument:&ispresenting atIndex:2];
        [invocation setSelector:selector];
        [invocation setTarget:self.transitionAnimationClass];
        [invocation invoke];
        void* ret = nil;
        [invocation getReturnValue:&ret];
        return (__bridge id)ret;
    }else {
        return nil;
    }
}

@end
