//
//  HCTagsContentView.m
//
//  Created by Sheng on 2018/7/24.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import "HCTagsContentView.h"
#import "UIView+HCRectExtension.h"

#define HCSEARCH_MARGIN 10
#define HCSEARCH_COLORPolRandomColor self.colorPol[arc4random_uniform((uint32_t)self.colorPol.count)]
#define HCSEARCH_COLOR(r,g,b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]

#define INDEX_NUM 10000

@implementation UIColor (GSTagsContentView)

+ (instancetype)gs_colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    if (colorString.length < 6) {
        return [UIColor clearColor];
    }
    
    if ([colorString hasPrefix:@"0X"]) {
        colorString = [colorString substringFromIndex:2];
    }
    
    if ([colorString hasPrefix:@"#"]) {
        colorString = [colorString substringFromIndex:1];
    }
    
    if (colorString.length != 6) {
        return [UIColor clearColor];
    }
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [colorString substringWithRange:range];
    
    // g
    range.location = 2;
    NSString *gString = [colorString substringWithRange:range];
    
    // b
    range.location = 4;
    NSString *bString = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:(float)r / 255.0 green:(float)g / 255.0 blue:(float)b / 255.0 alpha:1.0];
}

+ (instancetype)gs_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [[self gs_colorWithHexString:hexString] colorWithAlphaComponent:alpha];
}

@end

@implementation HCTagsContentView
{
    NSMutableArray *_tagViews;
    
    NSMutableArray<UIColor *> *_colorPol;
    NSInteger _selectIndex;
    NSMutableArray *_selectedIndexs;
    NSMutableArray *_tagColors;
}

- (NSMutableArray *)colorPol
{
    if (!_colorPol) {
        NSArray *colorStrPol = @[@"009999", @"0099cc", @"0099ff", @"00cc99", @"00cccc", @"336699", @"3366cc", @"3366ff", @"339966", @"666666", @"666699", @"6666cc", @"6666ff", @"996666", @"996699", @"999900", @"999933", @"99cc00", @"99cc33", @"660066", @"669933", @"990066", @"cc9900", @"cc6600" , @"cc3300", @"cc3366", @"cc6666", @"cc6699", @"cc0066", @"cc0033", @"ffcc00", @"ffcc33", @"ff9900", @"ff9933", @"ff6600", @"ff6633", @"ff6666", @"ff6699", @"ff3366", @"ff3333"];
        NSMutableArray *colorPolM = [NSMutableArray array];
        for (NSString *colorStr in colorStrPol) {
            UIColor *color = [UIColor gs_colorWithHexString:colorStr];
            [colorPolM addObject:color];
        }
        _colorPol = colorPolM;
    }
    return _colorPol;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame tags:(NSArray <NSString *>*)tagTexts handler:(void (^)(NSInteger index, NSString *text,BOOL isSelect))handler {
    if (self = [super initWithFrame:frame]) {
        [self setTagTexts:tagTexts];
        [self setup];
        self.handler = handler;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _selectIndex = -1;
    _defaultSelected = NO;
    _allowSelect = NO;
    _supportMultiSelect = NO;
}

- (HCTagsContentView * (^) (BOOL defaultSelected))defaultSelectedSet {
    return ^(BOOL defaultSelected) {
        self->_defaultSelected = defaultSelected;
        return self;
    };
}

- (HCTagsContentView * (^) (BOOL allowSelect))allowSelectSet{
    return ^(BOOL allowSelect) {
        self->_allowSelect = allowSelect;
        return self;
    };
}
- (HCTagsContentView * (^) (BOOL supportMultiSelect))supportMultiSelectSet {
    return ^(BOOL supportMultiSelect) {
        self->_supportMultiSelect = supportMultiSelect;
        return self;
    };
}

- (HCTagsContentView * (^) (GSTagHandler handler))handlerSet {
    return ^(GSTagHandler handler) {
        self->_handler = handler;
        return self;
    };
}

- (void)setTagTexts:(NSArray<NSString *> *)tagTexts {
    _tagTexts = tagTexts;
    for (UIView *view in self->_tagViews) {
        [view removeFromSuperview];
    }
    [self->_selectedIndexs removeAllObjects];
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tagTexts.count; i++) {
        UILabel *label = [self labelWithTitle:tagTexts[i]];
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [self addSubview:label];
        [tagsM addObject:label];
    }
    _tagViews = tagsM;
    [self setTagStyle];
}

- (HCTagsContentView * (^) (NSArray <NSString *>*tagTexts))tagTextsSet {
    return ^(NSArray <NSString *>*tagTexts) {
        self.tagTexts = tagTexts;
        return self;
    };
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (_tagViews.count > selectIndex) {
        if (_allowSelect) {
            if (!_supportMultiSelect) {
                if (_selectIndex != -1) {
                    UILabel *label1 = [_tagViews objectAtIndex:_selectIndex];
                    label1.textColor = [UIColor grayColor];
                    label1.backgroundColor = [UIColor clearColor];
                    label1.layer.borderColor = HCSEARCH_COLOR(223, 223, 223).CGColor;
                    label1.layer.borderWidth = 0.5;
                }
                _selectIndex = selectIndex;
                UILabel *label = [self viewWithTag:INDEX_NUM + selectIndex];
                label.textColor = [UIColor whiteColor];
                label.layer.borderColor = nil;
                label.layer.borderWidth = 0.0;
                label.backgroundColor = [_tagColors objectAtIndex:_selectIndex];
            }
        }
    }
}

- (void)tagDidCLick:(UITapGestureRecognizer *)gr
{
    UILabel *label = (UILabel *)gr.view;
    // popular search tagLabel's tag is 1, search history tagLabel's tag is 0.
    NSInteger index = [_tagViews indexOfObject:label];
    if (_allowSelect) {
        if (!_supportMultiSelect) {
            if (_selectIndex != -1) {
                UILabel *label1 = [_tagViews objectAtIndex:_selectIndex];
                label1.textColor = [UIColor grayColor];
                label1.backgroundColor = [UIColor clearColor];
                label1.layer.borderColor = HCSEARCH_COLOR(223, 223, 223).CGColor;
                label1.layer.borderWidth = 0.5;
            }
            _selectIndex = index;
            label.textColor = [UIColor whiteColor];
            label.layer.borderColor = nil;
            label.layer.borderWidth = 0.0;
            label.backgroundColor = [_tagColors objectAtIndex:_selectIndex];
            if (self.handler) {
                self.handler([_tagViews indexOfObject:label],label.text,YES);
                return;
            }
        }else{
            NSNumber* selectedNum = nil;
            for (NSNumber *num in _selectedIndexs) {
                if (num.integerValue == index) {
                    selectedNum = num;
                    break;
                }
            }
            if (!selectedNum) {
                [_selectedIndexs addObject:[NSNumber numberWithInteger:index]];
                _selectIndex = index;
                label.textColor = [UIColor whiteColor];
                label.layer.borderColor = nil;
                label.layer.borderWidth = 0.0;
                label.backgroundColor = [_tagColors objectAtIndex:_selectIndex];
                if (self.handler) {
                    self.handler([_tagViews indexOfObject:label],label.text,YES);
                    return;
                }
            }else{
                [_selectedIndexs removeObject:selectedNum];
                label.textColor = [UIColor grayColor];
                label.backgroundColor = [UIColor clearColor];
                label.layer.borderColor = HCSEARCH_COLOR(223, 223, 223).CGColor;
                label.layer.borderWidth = 0.5;
                if (self.handler) {
                    self.handler([_tagViews indexOfObject:label],label.text,NO);
                    return;
                }
            }
        }
    }else {
        if (self.handler) {
            self.handler([_tagViews indexOfObject:label],label.text,YES);
            return;
        }
    }
    
    
}

- (void)setSupportMultiSelect:(BOOL)supportMultiSelect {
    if (_supportMultiSelect != supportMultiSelect) {
        _supportMultiSelect = supportMultiSelect;
    }
    if (supportMultiSelect && !_selectedIndexs) {
        _selectedIndexs = [NSMutableArray array];
    }
}

- (void)__layoutTags {
    if (self.superview) {
        CGFloat currentX = 0;
        CGFloat currentY = 0;
        CGFloat countRow = 0;
        CGFloat countCol = 0;
        for (int i = 0; i < self.subviews.count; i++) {
            UILabel *subView = self.subviews[i];
            // When the number of search words is too large, the width is width of the contentView
            if (subView.hc_width > self.hc_width) subView.hc_width = self.hc_width;
            if (currentX + subView.hc_width + HCSEARCH_MARGIN * countRow > self.hc_width) {
                subView.hc_x = 0;
                subView.hc_y = (currentY += subView.hc_height) + HCSEARCH_MARGIN * ++countCol;
                currentX = subView.hc_width;
                countRow = 1;
            } else {
                subView.hc_x = (currentX += subView.hc_width) - subView.hc_width + HCSEARCH_MARGIN * countRow;
                subView.hc_y = currentY + HCSEARCH_MARGIN * countCol;
                countRow ++;
            }
        }
        self.hc_height = CGRectGetMaxY(self.subviews.lastObject.frame);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self __layoutTags];
}

- (void)setTagStyle {
    NSMutableArray *colors = [NSMutableArray array];
    for (int i = 0; i < _tagViews.count; i++) {
        UILabel *tag = _tagViews[i];
        if (_allowSelect && !_defaultSelected) {
            
            tag.textColor = [UIColor grayColor];
            tag.backgroundColor = [UIColor clearColor];
            tag.layer.borderColor = HCSEARCH_COLOR(223, 223, 223).CGColor;
            tag.layer.borderWidth = 0.5;
            if (_selectIndex == i) {
                tag.textColor = [UIColor whiteColor];
                UIColor *color = HCSEARCH_COLORPolRandomColor;
                tag.backgroundColor = color;
                [colors addObject:color];
            }else{
                [colors addObject:HCSEARCH_COLORPolRandomColor];
            }
        }else{
            tag.textColor = [UIColor whiteColor];
            tag.layer.borderColor = nil;
            tag.layer.borderWidth = 0.0;
            tag.backgroundColor = HCSEARCH_COLORPolRandomColor;
            [colors addObject:tag.backgroundColor];
            if (_supportMultiSelect) {
                NSInteger index = [_tagViews indexOfObject:tag];
                [_selectedIndexs addObject:[NSNumber numberWithInteger:index]];
            }
        }
    }
    _tagColors = colors;
}




- (UILabel *)labelWithTitle:(NSString *)title index:(int)index {
    UILabel *label = [self labelWithTitle:title];
    label.tag = INDEX_NUM + index;
    return label;
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.userInteractionEnabled = YES;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor gs_colorWithHexString:@"#fafafa"];
    label.layer.cornerRadius = 3;
    label.clipsToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.hc_width += 20;
    label.hc_height += 14;
    return label;
}


- (void)dealloc {
    if (_handler) {
        _handler = nil;
    }
}


@end
