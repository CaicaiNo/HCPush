//
//  HCPushLeftAnimation.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCPushHorizonalAnimation.h"

@implementation HCPushHorizonalAnimation

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresenting) {
        return 0.45;
    }
    return 0.25;
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseSettingViewController *settingvc = (HCBaseSettingViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    settingvc.backgroundView.alpha = 0.0;
    
    if (settingvc.isTransitionAnimate) {
        CGAffineTransform transform;
        if (settingvc.alignment == HCBaseSettingAlignmentRight) {
            transform = CGAffineTransformMakeTranslation(settingvc.hcContentView.bounds.size.width, 0);
        }else {
            transform = CGAffineTransformMakeTranslation(-settingvc.hcContentView.bounds.size.width, 0);
        }
        settingvc.hcContentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,transform);
    }
    
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:settingvc.view];
    
    if (settingvc.isTransitionAnimate) {
        [UIView animateWithDuration:0.25 animations:^{
            settingvc.backgroundView.alpha = 1.0;
            settingvc.hcContentView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                settingvc.hcContentView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }];
    }else {
        settingvc.backgroundView.alpha = 1.0;
        settingvc.hcContentView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:YES];
    }
    
    
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    HCBaseSettingViewController *settingvc = (HCBaseSettingViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if (settingvc.isTransitionAnimate) {
        [UIView animateWithDuration:0.25 animations:^{
            CGAffineTransform transform;
            if (settingvc.alignment == HCBaseSettingAlignmentRight) {
                transform = CGAffineTransformMakeTranslation(settingvc.hcContentView.bounds.size.width, 0);
            }else {
                transform = CGAffineTransformMakeTranslation(-settingvc.hcContentView.bounds.size.width, 0);
            }
            settingvc.hcContentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity, transform);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else {
        [transitionContext completeTransition:YES];
    }
    
}

@end
