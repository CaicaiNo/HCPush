//
//  HCBaseAnimation.h
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//


// Set TYAlertController https://github.com/12207480/TYAlertController

#import <Foundation/Foundation.h>
#import "HCBaseSettingViewController.h"

@interface HCBaseAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign, readonly) BOOL isPresenting; // present . dismiss

+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting;


// override transiton time
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext;

// override present
- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

// override dismiss
- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

