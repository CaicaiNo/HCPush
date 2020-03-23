//
//  HCBaseDefaultAnimation.m
//  HCBaseViewControllerDemo
//
//  Created by SunYong on 15/9/1.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "HCBaseFadeAnimation.h"
#import "HCBaseViewController.h"
@implementation HCBaseFadeAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        return 0.45;
    }
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseViewController *baseController = (HCBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    baseController.backgroundView.alpha = 0.0;
    
    baseController.hcContentView.alpha = 0.0;
    baseController.hcContentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:baseController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        baseController.backgroundView.alpha = 1.0;
        baseController.hcContentView.alpha = 1.0;
        baseController.hcContentView.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            baseController.hcContentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }];
    
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseViewController *baseController = (HCBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.25 animations:^{
        baseController.backgroundView.alpha = 0.0;
        baseController.hcContentView.alpha = 0.0;
        baseController.hcContentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
