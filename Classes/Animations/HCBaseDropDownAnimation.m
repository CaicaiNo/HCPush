//
//  HCBaseDropDownAnimation.m
//  HCBaseViewControllerDemo
//
//  Created by tanyang on 15/10/27.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "HCBaseDropDownAnimation.h"
#import "HCBaseViewController.h"
@implementation HCBaseDropDownAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        return 0.5;
    }
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseViewController *baseController = (HCBaseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    baseController.backgroundView.alpha = 0.0;
    
    baseController.hcContentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetMaxY(baseController.hcContentView.frame));
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:baseController.view];

    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:0 animations:^{
        
        baseController.backgroundView.alpha = 1.0;
        baseController.hcContentView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
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
