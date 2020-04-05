//
//  HCPush.h
//  HCPushSettingViewController
//
//  Created by sheng on 2020/3/23.
//  Copyright © 2020 haocaihaocai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCPushSettingViewController.h"

@interface HCPush : NSObject

@property (nonatomic, strong,readonly) HCPushSettingViewController *pushVC;

+ (instancetype)create;
///Content view background Color
- (HCPush *(^)(UIColor *color))ctbgColor;
///hcContentView`s size, default is {300,MAXFLOAT},MAXFLOAT means will fill screen height
- (HCPush *(^)(CGSize size))ctSize;
///Content EdgeInset ,Only Top and Bottom value is validate,left and right will be ignored. Default is UIEdgeInsetsZero
- (HCPush *(^)(UIEdgeInsets insets))ctInsets;
///The final view postion,default is Right
- (HCPush *(^)(HCPushSettingAlignment align))align;
///transition animation
- (HCPush *(^)(HCBaseTransitionAnimation animation))transition;
///custom transition class
- (HCPush *(^)(Class anmaClass))amclass;
///Transition is animate,default is YES
- (HCPush *(^)(BOOL isAnimate))animated;
///If backgroundView not set,the value will effect backgroundView`s color
- (HCPush *(^)(UIColor *bgColor))bgColor;
///backgroundView
- (HCPush *(^)(UIView *bgView))bgView;
///Tag backgoundView will cause ViewController dismiss
- (HCPush *(^)(BOOL tapDismiss))tapDismiss;
///dismiss controller completed block
- (HCPush *(^)(void (^)(void) ))dismissblock;
///a weak point to contentController,HCPushSettingViewController add it to childViewControllers
- (HCPush *(^)(UIViewController *child))childvc;
///if you only want to add a content view ,not a viewController,use this property
- (HCPush *(^)(UIView *childv))childview;
/// supportedInterfaceOrientations
- (HCPush *(^)(UIInterfaceOrientationMask mask))vcMask;
/// preferredInterfaceOrientationForPresentation
- (HCPush *(^)(UIInterfaceOrientation orientation))preferOrien;
/// shouldAutorotate
- (HCPush *(^)(BOOL autoRotation))vcrotation;

// viewController lifecycle block, return pushChildViewController.view
- (HCPush *(^)(void (^)(UIView *view)))willshow;
- (HCPush *(^)(void (^)(UIView *view)))didshow;
- (HCPush *(^)(void (^)(UIView *view)))willhide;
- (HCPush *(^)(void (^)(UIView *view)))didhide;

//done return vc
- (HCPushSettingViewController *)done;
@end

