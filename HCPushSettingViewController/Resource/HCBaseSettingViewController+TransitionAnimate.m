//
//  HCBaseSettingViewController+TransitionAnimate.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCBaseSettingViewController.h"
#import "HCPushHorizonalAnimation.h"
@implementation HCBaseSettingViewController (TransitionAnimate)
#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [HCPushHorizonalAnimation alertAnimationIsPresenting:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [HCPushHorizonalAnimation alertAnimationIsPresenting:NO];
}

@end
