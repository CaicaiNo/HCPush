//
//  HCTagsContentView.h
//
//  Created by Sheng on 2018/7/24.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GSTagHandler)(NSInteger index, NSString *text,BOOL isSelect);

@interface HCTagsContentView : UIView

@property (nonatomic, assign) BOOL defaultSelected; //所有tag初始化为选中状态
- (HCTagsContentView * (^) (BOOL defaultSelected))defaultSelectedSet;

@property (nonatomic, assign) BOOL allowSelect; //允许选择 default NO -  YES :默认为灰色底色，选择后变颜色
- (HCTagsContentView * (^) (BOOL allowSelect))allowSelectSet;

@property (nonatomic, assign) BOOL supportMultiSelect; //是否支持多选
- (HCTagsContentView * (^) (BOOL supportMultiSelect))supportMultiSelectSet;

@property (nonatomic, strong) NSArray <NSString *>*tagTexts;
- (HCTagsContentView * (^) (NSArray <NSString *>*tagTexts))tagTextsSet;

@property (nonatomic, copy) GSTagHandler handler;
- (HCTagsContentView * (^) (GSTagHandler handler))handlerSet;

///< 选中index,默认为-1
@property (nonatomic, assign) NSInteger selectIndex;
///UIColor
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *noSelectColor;

- (instancetype)initWithFrame:(CGRect)frame tags:(NSArray <NSString *>*)tagTexts handler:(void (^)(NSInteger index, NSString *text,BOOL isSelect))handler;

@end

