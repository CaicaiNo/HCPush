//
//  HCBaseAnimation.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCBaseAnimation.h"
@interface HCBaseAnimation ()
@property (nonatomic, assign) BOOL isPresenting;
@end


@implementation HCBaseAnimation

- (instancetype)initWithIsPresenting:(BOOL)isPresenting
{
    if (self = [super init]) {
        self.isPresenting = isPresenting;
    }
    return self;
}

+ (instancetype)alertAnimationIsPresenting:(BOOL)isPresenting
{
    return [[self alloc]initWithIsPresenting:isPresenting];
}

// override this moethod
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_isPresenting) {
        [self presentAnimateTransition:transitionContext];
    }else {
        [self dismissAnimateTransition:transitionContext];
    }
}

- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
}

- (void)dealloc {
    NSLog(@"HCBaseAnimation dealloc");
}

@end
