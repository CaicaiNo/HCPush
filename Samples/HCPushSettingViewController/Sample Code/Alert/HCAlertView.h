//
//  HCAlertView.h
//  HCPushSettingViewController
//
//  Created by gensee on 2020/3/23.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(HCAlertAction *action))handler;
@property (nonatomic, strong, readonly) UIButton *button;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, getter=isEnabled) BOOL enabled;

+ (HCAlertAction *)create;
- (HCAlertAction *(^)(NSString *str))tlt;
- (HCAlertAction *(^)(void (^)(HCAlertAction *bl)))action;
- (HCAlertAction *(^)(BOOL enable))valid;
- (HCAlertAction *(^)(void(^)(UIButton *btn)))optBtn;


@end

@interface HCAlertView : UIView
///title
@property (nonatomic, weak, readonly) UILabel *titleLable;
/// only top left right valid
@property (nonatomic, assign) UIEdgeInsets titleInsets;
///message
@property (nonatomic, weak, readonly) UITextView *messageLabel;
/// only top left right valid
@property (nonatomic, assign) UIEdgeInsets messageInsets;


@property (nonatomic, assign) UIEdgeInsets buttonsInsets;
@property (nonatomic, assign) CGFloat buttonVerticalSpacing;
@property (nonatomic, assign) CGFloat buttonCornerRadius;
@property (nonatomic, assign) BOOL clickedAutoHide;
///default is 280
@property (nonatomic, assign) CGFloat alertViewWidth;

#pragma method

+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;
- (void)addAction:(HCAlertAction *)action;

#pragma mark - DST
+ (HCAlertView *)create;
- (HCAlertView *(^)(NSAttributedString *str))attr;
- (HCAlertView *(^)(NSAttributedString *str))title;
- (HCAlertView *(^)(HCAlertAction *action))add;
- (HCAlertView *(^)(BOOL (^)(NSURL *url)))urlAction;
@end

