//
//  HCPush.m
//  HCPushSettingViewController
//
//  Created by sheng on 2020/3/23.
//  Copyright © 2020 haocaihaocai. All rights reserved.
//

#import "HCPush.h"


@interface HCPush ()

@property (nonatomic, strong) HCPushSettingViewController *pushVC;

@end

@implementation HCPush

- (instancetype)init {
    if (self = [super init]) {
        _pushVC = [[HCPushSettingViewController alloc] init];
    }
    return self;
}

+ (instancetype)create{
    return [[self alloc]init];
}

///Content view background Color
- (HCPush *(^)(UIColor *color))ctbgColor {
    return ^HCPush *(UIColor *color) {
        self.pushVC.hcContentViewBackgroundColor = color;
        return self;
    };
}
///hcContentView`s size, default is {300,MAXFLOAT},MAXFLOAT means will fill screen height
- (HCPush *(^)(CGSize size))ctSize {
    return ^HCPush *(CGSize size) {
        self.pushVC.hcContentSize = size;
        return self;
    };
}
///Content EdgeInset ,Only Top and Bottom value is validate,left and right will be ignored. Default is UIEdgeInsetsZero
- (HCPush *(^)(UIEdgeInsets insets))ctInsets {
    return ^HCPush *(UIEdgeInsets insets) {
        self.pushVC.contentInset = insets;
        return self;
    };
}
///The final view postion,default is Right
- (HCPush *(^)(HCPushSettingAlignment align))align {
    return ^HCPush *(HCPushSettingAlignment align) {
        self.pushVC.alignment = align;
        return self;
    };
}
///transition animation
- (HCPush *(^)(HCBaseTransitionAnimation animation))transition {
    return ^HCPush *(HCBaseTransitionAnimation animation) {
        self.pushVC.transitionAnimation = animation;
        return self;
    };
}
///custom transition class
- (HCPush *(^)(Class anmaClass))amclass {
    return ^HCPush *(Class anmaClass) {
        self.pushVC.transitionAnimationClass = anmaClass;
        return self;
    };
}
///Transition is animate,default is YES
- (HCPush *(^)(BOOL isAnimate))animated {
    return ^HCPush *(BOOL isAnimate) {
        self.pushVC.isTransitionAnimate = isAnimate;
        return self;
    };
}
///If backgroundView not set,the value will effect backgroundView`s color
- (HCPush *(^)(UIColor *bgColor))bgColor {
    return ^HCPush *(UIColor *bgColor) {
        self.pushVC.backgroundColor = bgColor;
        return self;
    };
}
///backgroundView
- (HCPush *(^)(UIView *bgView))bgView {
    return ^HCPush *(UIView *bgView) {
        self.pushVC.backgroundView = bgView;
        return self;
    };
}
///Tag backgoundView will cause ViewController dismiss
- (HCPush *(^)(BOOL tapDismiss))tapDismiss {
    return ^HCPush *(BOOL tapDismiss) {
        self.pushVC.backgoundTapDismissEnable = tapDismiss;
        return self;
    };
}
///dismiss controller completed block
- (HCPush *(^)(void (^)(void) ))dismissblock {
    return ^HCPush *(void (^block)(void)) {
        self.pushVC.dismissComplete = block;
        return self;
    };
}
///a weak point to contentController,HCPushSettingViewController add it to childViewControllers
- (HCPush *(^)(UIViewController *child))childvc {
    return ^HCPush *(UIViewController *child) {
        self.pushVC.pushChildViewController = child;
        return self;
    };
}
///if you only want to add a content view ,not a viewController,use this property
- (HCPush *(^)(UIView *childv))childview {
    return ^HCPush *(UIView *childv) {
        self.pushVC.childView = childv;
        return self;
    };
}
// viewController lifecycle block, return pushChildViewController.view
- (HCPush *(^)(void (^)(UIView *view)))willshow {
    return ^HCPush *(void (^block)(UIView *view)) {
        self.pushVC.viewWillShowHandler = block;
        return self;
    };
}
- (HCPush *(^)(void (^)(UIView *view)))didshow {
    return ^HCPush *(void (^block)(UIView *view)) {
        self.pushVC.viewDidShowHandler = block;
        return self;
    };
}
- (HCPush *(^)(void (^)(UIView *view)))willhide {
    return ^HCPush *(void (^block)(UIView *view)) {
        self.pushVC.viewWillHideHandler = block;
        return self;
    };
}
- (HCPush *(^)(void (^)(UIView *view)))didhide {
    return ^HCPush *(void (^block)(UIView *view)) {
        self.pushVC.viewDidHideHandler = block;
        return self;
    };
}

- (HCPushSettingViewController *)done {
    return self.pushVC;
}

@end
