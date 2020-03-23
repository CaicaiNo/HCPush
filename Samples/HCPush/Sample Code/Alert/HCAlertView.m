//
//  HCAlertView.m
//  HCPushSettingViewController
//
//  Created by gensee on 2020/3/23.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCAlertView.h"

#define kButtonTagOffset 1000
#define kButtonHeight 44

@interface HCAlertAction ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) void (^handler)(HCAlertAction *);
@property (nonatomic, strong) UIButton *button;
@end

@implementation HCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(HCAlertAction *))handler
{
    return [[self alloc]initWithTitle:title handler:handler];
}

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(HCAlertAction *))handler
{
    if (self = [super init]) {
        _title = title;
        _handler = handler;
        _enabled = YES;
        
    }
    return self;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.clipsToBounds = YES;
        [button setTitle:self.title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        button.enabled = YES;
        _button = button;;
    }
    return _button;
}


- (id)copyWithZone:(NSZone *)zone
{
    HCAlertAction *action = [[self class]allocWithZone:zone];
    action.title = self.title;
    return action;
}

+ (HCAlertAction *)create {
    return [[self alloc] init];
}

- (HCAlertAction *(^)(NSString *str))tlt {
    return ^(NSString *str) {
        self.title = str;
        return self;
    };
}

- (HCAlertAction *(^)(void (^)(HCAlertAction *bl)))action {
    return ^(void(^block)(HCAlertAction *)) {
        self.handler = block;
        return self;
    };
}

- (HCAlertAction *(^)(BOOL enable))valid {
    return ^(BOOL enable) {
        self.enabled = enable;
        return self;
    };
}
- (HCAlertAction *(^)(void(^)(UIButton *btn)))optBtn {
    return ^(void(^block)(UIButton *btn)) {
        if (self.button) block(self.button);
        return self;
    };
}

@end

@interface HCAlertView() <UITextViewDelegate>

// text content View
@property (nonatomic, weak) UIView *textContentView;
@property (nonatomic, weak) UIView *buttonContentView;
@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UITextView *messageLabel;


@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *actions;

@property (nonatomic, strong) NSMutableArray *buttonConstraints;

@property (nonatomic, copy) void(^linkHandler)(NSURL *url);
///set link text color
@property (nonatomic, strong) UIColor *mlinkColor;
@end

@implementation HCAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureProperty];
        [self addContentViews];
        [self addTextLabels];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    if (self = [self init]) {
        
        
        
        [self configureProperty];
        [self addContentViews];
        [self addTextLabels];
        
        _titleLable.text = title;
        _messageLabel.text = message;
    }
    return self;
}

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message
{
    return [[self alloc]initWithTitle:title message:message];
}


- (void)configureProperty
{
    _clickedAutoHide = YES;
    self.backgroundColor = [UIColor whiteColor];
    _buttonCornerRadius = kButtonHeight/2;
    
    _buttons = [NSMutableArray array];
    _actions = [NSMutableArray array];
    _buttonConstraints = [NSMutableArray array];
    
    _titleInsets = UIEdgeInsetsMake(15, 0, 0, 0);
    _buttonsInsets = UIEdgeInsetsMake(10, 20, -32, -20);
    _messageInsets = UIEdgeInsetsMake(0, 20, -10, -20);;
    _buttonVerticalSpacing = 12.f;
    
}

- (void)addContentViews
{
    UIView *textContentView = [[UIView alloc]init];
    [self addSubview:textContentView];
    _textContentView = textContentView;
    
    UIView *buttonContentView = [[UIView alloc]init];
    buttonContentView.userInteractionEnabled = YES;
    buttonContentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:buttonContentView];
    _buttonContentView = buttonContentView;
    self.layer.cornerRadius = 8.0;
}

- (void)addTextLabels
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    [_textContentView addSubview:titleLabel];
    _titleLable = titleLabel;
    
    UITextView *messageLabel = [[UITextView alloc]init];
//    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    messageLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    messageLabel.delegate = self;
    messageLabel.editable = NO;
    messageLabel.selectable = NO;
    messageLabel.delaysContentTouches = NO;
    [_textContentView addSubview:messageLabel];
    _messageLabel = messageLabel;
    if (_mlinkColor) {
        _messageLabel.linkTextAttributes = @{NSForegroundColorAttributeName:_mlinkColor};
    }
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTextView:)];
    [_messageLabel addGestureRecognizer:tapRecognizer];
    
}

- (void)addAction:(HCAlertAction *)action
{
    if (!action) {
        return;
    }
    UIButton *button = action.button;
    if ([_buttons containsObject:button] || !button) {
        //filter dupicate
        return;
    }
    button.tag = kButtonTagOffset + _buttons.count;
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_buttonContentView addSubview:button];
    [_buttons addObject:button];
    [_actions addObject:action];
}

#pragma mark - DST

+ (HCAlertView *)create {
    return [[self alloc] initWithTitle:@"Title" message:@"Message"];
}

- (HCAlertView *(^)(NSAttributedString *str))title {
    return ^(NSAttributedString *str) {
        self.titleLable.attributedText = str;
        return self;
    };
}

- (HCAlertView *(^)(NSAttributedString *str))attr {
    return ^(NSAttributedString *str) {
        self.messageLabel.attributedText = str;
        return self;
    };
}

- (HCAlertView *(^)(HCAlertAction *action))add {
    return ^(HCAlertAction *action) {
        [self addAction:action];
        return self;
    };
}

- (HCAlertView *(^)(void (^)(NSURL *url)))urlAction {
    return ^(void (^block)(NSURL *url)) {
        
        self.linkHandler = block;
        return self;
    };
}

- (HCAlertView *(^)(UIColor *linkColor))linkColor {
    return ^(UIColor *cr) {
        self.mlinkColor = cr;
        self.messageLabel.linkTextAttributes = @{NSForegroundColorAttributeName:self.mlinkColor};
        return self;
    };
}

#pragma mark - gesture

#pragma mark - layout

- (void)layoutContentViews {
    if (!_textContentView.translatesAutoresizingMaskIntoConstraints) {
        // layout done
        return;
    }
    
    if (_alertViewWidth) {
        NSMutableArray *cons = [NSMutableArray array];
        [cons addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
        [cons addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:300]];
        [self applyPriority:996.f toConstraints:cons];
    }
    
    
    // textContentView
    _textContentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self addConstraintWithView:_textContentView topView:self leftView:self bottomView:nil rightView:self edgeInset:UIEdgeInsetsZero];
}

- (void)layoutTextLabels
{
    if (!_titleLable.translatesAutoresizingMaskIntoConstraints && !_messageLabel.translatesAutoresizingMaskIntoConstraints) {
        // layout done
        return;
    }
    // title
    if (_titleLable.text.length > 0) {
        _titleLable.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraintWithView:_titleLable topView:_textContentView leftView:_textContentView bottomView:nil rightView:_textContentView edgeInset:UIEdgeInsetsMake(_titleInsets.top, _titleInsets.left, 0, _titleInsets.right)];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_titleLable attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:35]];
        // message
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_textContentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_messageLabel attribute:NSLayoutAttributeTop multiplier:1 constant:_messageInsets.top]];
        
        [self addConstraintWithView:_messageLabel topView:nil leftView:_textContentView bottomView:_textContentView rightView:_textContentView edgeInset:UIEdgeInsetsMake(0, _messageInsets.left, 0, _messageInsets.right)];
    }else {
        // message
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraintWithView:_messageLabel topView:_textContentView leftView:_textContentView bottomView:_textContentView rightView:_textContentView edgeInset:UIEdgeInsetsMake(_messageInsets.top, _messageInsets.left, 0, _messageInsets.right)];
    }
    
}

- (void)layoutButtons {
    [self removeConstraints:self.buttonConstraints];
    [self.buttonConstraints removeAllObjects];
    
    if (_buttons.count == 0) {
        NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:_textContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
        layout.priority = 998.f;
        [self.buttonConstraints addObject:layout];
       
    }else {
        //button content
        NSMutableArray *consmuta = [NSMutableArray array];
        [consmuta addObject:[NSLayoutConstraint constraintWithItem:_buttonContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:_buttonsInsets.left]];
        [consmuta addObject:[NSLayoutConstraint constraintWithItem:_buttonContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_textContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:_buttonsInsets.top]];
        [consmuta addObject:[NSLayoutConstraint constraintWithItem:_buttonContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:_buttonsInsets.right]];
        [consmuta addObject:[NSLayoutConstraint constraintWithItem:_buttonContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:_buttonsInsets.bottom]];
        [self applyPriority:998.f toConstraints:consmuta];
        [self.buttonConstraints addObjectsFromArray:consmuta];
        //buttons
        UIButton *pre = nil;
        for (int i = 0; i <  _buttons.count; i++) {
            UIButton *button = _buttons[i];
            if (pre == nil) {
                NSMutableArray *consmuta = [NSMutableArray array];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:kButtonHeight]];
                [self applyPriority:998.f toConstraints:consmuta];
                [self.buttonConstraints addObjectsFromArray:consmuta];
            }else {
                NSMutableArray *consmuta = [NSMutableArray array];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pre attribute:NSLayoutAttributeBottom multiplier:1 constant:_buttonVerticalSpacing]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:1 constant:kButtonHeight]];
                [self applyPriority:998.f toConstraints:consmuta];
                [self.buttonConstraints addObjectsFromArray:consmuta];
            }
            pre = button;
            if (i == _buttons.count - 1) {
                NSMutableArray *consmuta = [NSMutableArray array];
                [consmuta addObject:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_buttonContentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
                [self applyPriority:998.f toConstraints:consmuta];
                [self.buttonConstraints addObjectsFromArray:consmuta];
            }
        }
    }
    [self addConstraints:self.buttonConstraints];
}

- (void)applyPriority:(UILayoutPriority)priority toConstraints:(NSArray *)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.priority = priority;
    }
}


- (void)updateConstraints {
    [self layoutContentViews];
    [self layoutTextLabels];
    [self layoutButtons];
    [super updateConstraints];
}

#pragma mark - action

- (void)actionButtonClicked:(UIButton *)button
{
    HCAlertAction *action = _actions[button.tag - kButtonTagOffset];
    
    if (_clickedAutoHide) {
        UIViewController *mviewController = [self viewController];
        if (mviewController) {
            [mviewController dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
    if (action.handler) {
        action.handler(action);
    }
}


- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark - textview delegate

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
//    return NO;
//}
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
//    NSLog(@"shouldInteractWithURL url %@",URL);
//    if (self.linkHandler) {
//        return self.linkHandler(URL);
//    }else{
//        return NO;
//    }
//}

- (void)tappedTextView:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state != UIGestureRecognizerStateEnded) {
        return;
    }
    
    UITextView *textView = (UITextView *)tapGesture.view;
    CGPoint tapLocation = [tapGesture locationInView:textView];
    UITextPosition *textPosition = [textView closestPositionToPoint:tapLocation];
    if ([textView respondsToSelector:@selector(textStylingAtPosition:inDirection:)]) {
        NSDictionary *attributes = [textView textStylingAtPosition:textPosition inDirection:UITextStorageDirectionForward];
        NSURL *url = attributes[NSLinkAttributeName];
        if (url) {
            if (self.linkHandler) {
                self.linkHandler(url);
            }
        }
    }
    
}


#pragma mark - layout extern

- (void)addConstraintWithView:(UIView *)view topView:(UIView *)topView leftView:(UIView *)leftView
                   bottomView:(UIView *)bottomView rightView:(UIView *)rightView edgeInset:(UIEdgeInsets)edgeInset
{
    if (topView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:1 constant:edgeInset.top]];
    }
    
    if (leftView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeLeft multiplier:1 constant:edgeInset.left]];
    }
    
    if (rightView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:rightView attribute:NSLayoutAttributeRight multiplier:1 constant:edgeInset.right]];
    }
    
    if (bottomView) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:edgeInset.bottom]];
    }
}

@end
