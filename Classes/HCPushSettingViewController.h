//
//  HCPushSettingViewController.h
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//  https://github.com/haocaihaocai/HCPushSettingViewController.git

#import "HCBaseViewController.h"

@interface HCPushSettingViewController : HCBaseViewController
///a weak point to contentController,HCPushSettingViewController add it to childViewControllers
@property (nonatomic, strong) UIViewController *pushChildViewController;
///if you only want to add a content view ,not a viewController,use this property
@property (nonatomic, strong) UIView *childView;
/// supportedInterfaceOrientations
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
/// preferredInterfaceOrientationForPresentation
@property (nonatomic, assign) UIInterfaceOrientation preferrdOrientation;
/// shouldAutorotate
@property (nonatomic, assign) BOOL autoRotation;
// viewController lifecycle block, return pushChildViewController.view
@property (copy, nonatomic) void (^viewWillShowHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewDidShowHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewWillHideHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewDidHideHandler)(UIView *childView);

+ (instancetype)settingControllerWithContentController:(UIViewController *)controller;

@end


