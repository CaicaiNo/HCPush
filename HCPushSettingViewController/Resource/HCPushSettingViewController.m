//
//  HCPushSettingViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCPushSettingViewController.h"

@interface HCPushSettingViewController ()

@end

@implementation HCPushSettingViewController

- (instancetype)initWithContentController:(UIViewController *)controller {
    if (self = [super init]) {
        [self addPushControllerContent:controller];
    }
    return self;
}

+ (instancetype)settingControllerWithContentController:(UIViewController *)controller {
    return [[self alloc] initWithContentController:controller];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *childView = self.pushChildViewController.view;
    childView.translatesAutoresizingMaskIntoConstraints = NO;
    childView.frame = self.hcContentView.bounds;
    [self.hcContentView addSubview:childView];
    ///must add to hcContentView, not self.view
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.hcContentView addConstraint:[NSLayoutConstraint constraintWithItem:childView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.hcContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

- (void)addPushControllerContent:(UIViewController *)controller {
    _pushChildViewController = controller;
    [self addChildViewController:self.pushChildViewController];
}

#pragma mark - lift cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_viewWillShowHandler) {
        _viewWillShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_viewDidShowHandler) {
        _viewDidShowHandler(self.pushChildViewController.view);
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_viewWillHideHandler) {
        _viewWillHideHandler(self.pushChildViewController.view);
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_viewDidHideHandler) {
        _viewDidHideHandler(self.pushChildViewController.view);
    }
}

#pragma mark - rotation

- (BOOL)shouldAutorotate {
    if (_pushChildViewController) {
        return [_pushChildViewController shouldAutorotate];
    }
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if (_pushChildViewController) {
        return [_pushChildViewController preferredInterfaceOrientationForPresentation];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (_pushChildViewController) {
        return [_pushChildViewController supportedInterfaceOrientations];
    }
    //TODO:You can fix this value to set default
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
