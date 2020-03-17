//
//  HCPushSettingViewController.h
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCBaseSettingViewController.h"

@interface HCPushSettingViewController : HCBaseSettingViewController
///a weak point to contentController,HCPushSettingViewController add it to childViewControllers
@property (nonatomic, strong) UIViewController *pushChildViewController;


// viewController lifecycle block, return pushChildViewController.view
@property (copy, nonatomic) void (^viewWillShowHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewDidShowHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewWillHideHandler)(UIView *childView);
@property (copy, nonatomic) void (^viewDidHideHandler)(UIView *childView);

+ (instancetype)settingControllerWithContentController:(UIViewController *)controller;

@end

@interface HCProxy : NSProxy
@property (nonatomic, weak, readonly) id target;
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end


@interface UIViewController (HCPush)
//use Proxy to avoid retain cycle
@property (nonatomic, strong) HCPushSettingViewController *HCParentController;

@end

