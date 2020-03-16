//
//  HCBaseSettingViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCBaseSettingViewController.h"
#include <sys/socket.h>
#include <sys/sysctl.h>

@interface HCBaseSettingViewController ()

@property (nonatomic, weak) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) NSMutableArray *contentConstraits;
@end

@implementation HCBaseSettingViewController

#pragma mark - init

- (instancetype)init {
    if (self = [super init]) {
        [self configureController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addBackgroundView];
    [self addhcContentView];
    [self addSingleTapGesture];
    [self.view layoutIfNeeded];
    // Do any additional setup after loading the view.
}
- (void)configureController
{
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    _contentInset = UIEdgeInsetsZero;
    _backgoundTapDismissEnable = YES;
    _isTransitionAnimate = YES;
    _hcContentSize = CGSizeMake(300, MAXFLOAT);
    _contentConstraits = [[NSMutableArray alloc] init];
    _backgroundColor = [UIColor clearColor];
    _hcContentViewBackgroundColor = [UIColor clearColor];
    [self registerForNotifications];
}

- (void)dealloc {
    [self unregisterFromNotifications];
}



#pragma mark - Notifications

- (void)registerForNotifications {
#if !TARGET_OS_TV
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(statusBarOrientationDidChange:)
               name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

- (void)unregisterFromNotifications {
#if !TARGET_OS_TV
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
#endif
}

#if !TARGET_OS_TV
- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    UIView *superview = self.view;
    if (!superview) {
        return;
    } else {
        [self updateViewConstraints];
    }
}
#endif

#pragma mark - Constraits




- (void)updateViewConstraints {
//    NSLog(@"updateViewConstraints");
    if (self.contentConstraits.count > 0) {
        [self.view removeConstraints:self.contentConstraits];
        [self.contentConstraits removeAllObjects];
    }
    
    if (_hcContentSize.height >= (self.view.bounds.size.height - _contentInset.top - _contentInset.bottom)) {
        //top and bottom
        [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:_contentInset.top]];
        [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-_contentInset.bottom]];
    }else if (_hcContentSize.height < (self.view.bounds.size.height - _contentInset.top - _contentInset.bottom)) {
        
        //center Y
        [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        //top and bottom
        NSMutableArray *tbconstraint = [NSMutableArray array];
        [tbconstraint addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:_contentInset.top]];
        [tbconstraint addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:-_contentInset.bottom]];
        [self applyPriority:999.f toConstraints:tbconstraint];
        [self.contentConstraits addObjectsFromArray:tbconstraint];
        //height
        NSLayoutConstraint *layoutHeight = [NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:_hcContentSize.height];
        layoutHeight.priority = 998.f;
        [self.contentConstraits addObject:layoutHeight];
    }
    
    if (_alignment == HCBaseSettingAlignmentRight) {
        [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }else {
        [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    }
    CGFloat width = _hcContentSize.width;
    if (_hcContentSize.width > self.view.bounds.size.width) {
        width = self.view.bounds.size.width - _contentInset.left;
    }
    [self.contentConstraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:width]];
    
    [self.view addConstraints:self.contentConstraits];
    
    [super updateViewConstraints];
}


- (void)applyPriority:(UILayoutPriority)priority toConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.priority = priority;
    }
}

- (void)addConstraintToView:(UIView *)view edgeInset:(UIEdgeInsets)edgeInset
{
    [self addConstraintWithView:view topView:self.view leftView:self.view bottomView:self.view rightView:self.view edgeInset:edgeInset];
}

- (void)addConstraintWithView:(UIView *)view topView:(UIView *)topView leftView:(UIView *)leftView
                   bottomView:(UIView *)bottomView rightView:(UIView *)rightView edgeInset:(UIEdgeInsets)edgeInset
{
    if (topView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
    }
    
    if (leftView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    }
    
    if (rightView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    }
    
    if (bottomView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
    }
}

#pragma mark - add Views

- (void)addhcContentView {
    if (_hcContentView == nil) {
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = _hcContentViewBackgroundColor;
        _hcContentView = backgroundView;
    }
    _hcContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_hcContentView];
    
    [self updateViewConstraints];
    
}

- (void)addBackgroundView
{
    if (_backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = _backgroundColor;
        _backgroundView = backgroundView;
    }
    _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_backgroundView atIndex:0];
    [self addConstraintToView:_backgroundView edgeInset:UIEdgeInsetsZero];
}


- (void)addSingleTapGesture
{
    self.view.userInteractionEnabled = YES;
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _backgoundTapDismissEnable;
    
    [_backgroundView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

#pragma mark - actions

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)animated
{
    [self dismissViewControllerAnimated:YES completion:self.dismissComplete];
}


@end
