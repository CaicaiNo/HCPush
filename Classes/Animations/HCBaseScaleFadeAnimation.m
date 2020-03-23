//
//  HCBaseScaleFadeAnimation.m
//  HCBaseViewControllerDemo
//
//  Created by SunYong on 15/9/2.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "HCBaseScaleFadeAnimation.h"
#import "HCBaseViewController.h"
@implementation HCBaseScaleFadeAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseViewController *baseController = (HCBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    baseController.backgroundView.alpha = 0.0;
    
    baseController.hcContentView.alpha = 0.0;
    baseController.hcContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:baseController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        baseController.backgroundView.alpha = 1.0;
        baseController.hcContentView.alpha = 1.0;
        baseController.hcContentView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseViewController *baseController = (HCBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        baseController.backgroundView.alpha = 0.0;
        baseController.hcContentView.alpha = 0.0;
        baseController.hcContentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
