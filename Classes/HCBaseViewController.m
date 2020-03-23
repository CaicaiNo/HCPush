//
//  HCBaseSettingViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCBaseViewController.h"


@interface HCBaseViewController ()

@property (nonatomic, weak) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) NSMutableArray *contentConstraits;
@end

@implementation HCBaseViewController

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
    self.transitionAnimation = HCBaseTransitionAnimationSlideDirectly;
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


- (void)__hcAddConstraits {
    if (!_hcContentView) {
        return;
    }
    if (_hcContentSize.height > 9999) _hcContentSize.height = [UIScreen mainScreen].bounds.size.height;
    if (_hcContentSize.width > 9999) _hcContentSize.width = [UIScreen mainScreen].bounds.size.height;
    /// add edge constraints
    NSMutableArray *sideConstraints = [NSMutableArray array];
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=left)-[_hcContentView]-(>=right)-|" options:0 metrics:@{@"left": @(_contentInset.left),@"right":@(ABS(_contentInset.right))} views:NSDictionaryOfVariableBindings(_hcContentView)]];
    [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=top)-[_hcContentView]-(>=bottom)-|" options:0 metrics:@{@"top": @(_contentInset.top),@"bottom":@(ABS(_contentInset.bottom))} views:NSDictionaryOfVariableBindings(_hcContentView)]];
    [self applyPriority:998.f toConstraints:sideConstraints];
    [self.contentConstraits addObjectsFromArray:sideConstraints];
    
    /// center constraits
    if (self.alignment == HCPushSettingAlignmentTop || self.alignment == HCPushSettingAlignmentBottom) {
        NSMutableArray *constraits = [NSMutableArray array];
        [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self applyPriority:997.f toConstraints:constraits];
        [self.contentConstraits addObjectsFromArray:constraits];
    }else if (self.alignment == HCPushSettingAlignmentLeft || self.alignment == HCPushSettingAlignmentRight){
        NSMutableArray *constraits = [NSMutableArray array];
        [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self applyPriority:997.f toConstraints:constraits];
        [self.contentConstraits addObjectsFromArray:constraits];
    }else if (self.alignment == HCPushSettingAlignmentCenter) {
        NSMutableArray *constraits = [NSMutableArray array];
        [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self applyPriority:997.f toConstraints:constraits];
        [self.contentConstraits addObjectsFromArray:constraits];
    }
    
    /// aligent constraits
    if (self.alignment == HCPushSettingAlignmentLeft) {
        NSLayoutConstraint *con =[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:_contentInset.left];
        con.priority = 999.f;
        [self.contentConstraits addObject:con];
    }else if (self.alignment == HCPushSettingAlignmentRight) {
        NSLayoutConstraint *con =[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:_contentInset.right];
        con.priority = 999.f;
        [self.contentConstraits addObject:con];
    }else if (self.alignment == HCPushSettingAlignmentTop) {
        NSLayoutConstraint *con =[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:_contentInset.top];
        con.priority = 999.f;
        [self.contentConstraits addObject:con];
    }else if (self.alignment == HCPushSettingAlignmentBottom) {
        NSLayoutConstraint *con =[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:_contentInset.bottom];
        con.priority = 999.f;
        [self.contentConstraits addObject:con];
    }
    
    //wxh
    NSMutableArray *constraits = [NSMutableArray array];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:_hcContentSize.height]];
    [constraits addObject:[NSLayoutConstraint constraintWithItem:_hcContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:_hcContentSize.width]];
    [self applyPriority:997.f toConstraints:constraits];
    [self.contentConstraits addObjectsFromArray:constraits];
}

- (void)updateViewConstraints {
//    NSLog(@"updateViewConstraints");
    if (self.contentConstraits.count > 0) {
        [self.view removeConstraints:self.contentConstraits];
        [self.contentConstraits removeAllObjects];
    }
    
    [self __hcAddConstraits];
    [self.view addConstraints:self.contentConstraits];
    
    [super updateViewConstraints];
}


#pragma mark -

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

#pragma mark - transition

- (void)setTransitionAnimation:(HCBaseTransitionAnimation)transitionAnimation {
    switch (transitionAnimation) {
        case HCBaseTransitionAnimationSlideDirectly:
            _transitionAnimationClass = NSClassFromString(@"HCPushAnimation");
            break;
        case HCBaseTransitionAnimationFade:
            _transitionAnimationClass = NSClassFromString(@"HCBaseFadeAnimation");
            break;
        case HCBaseTransitionAnimationScaleFade:
            _transitionAnimationClass = NSClassFromString(@"HCBaseScaleFadeAnimation");
            break;
        case HCBaseTransitionAnimationDropDown:
            _transitionAnimationClass = NSClassFromString(@"HCBaseDropDownAnimation");
            break;
        case HCBaseTransitionAnimationCustom:
            _transitionAnimationClass = nil;
        default:
            _transitionAnimationClass = NSClassFromString(@"HCPushAnimation");
            break;
    }
    _transitionAnimation = transitionAnimation;
}


@end
