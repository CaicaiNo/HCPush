//
//  HCTestView.m
//  HCPushSettingViewController
//
//  Created by gensee on 2020/3/20.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCTestView.h"
#import "HCTagsContentView.h"

@implementation HCTestView {
    HCTagsContentView *_tagsView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setTagsView];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTagsView];
    }
    return self;
}

- (void)setTagsView {
    self.backgroundColor = [UIColor colorWithRed:26/255.f green:26/255.f blue:26/255.f alpha:0.5];
    _tagsView = [[HCTagsContentView alloc] init];
    _tagsView.tagTextsSet(@[@"不爱的不断打扰",@"你爱的不在怀抱",@"得到手的不需要",@"渴望拥有的得不到",@"苦恼",@"倒不如说声笑笑",@"生活不要 太多钞票",@"多了就会带来困扰",@"过重的背包"]).allowSelectSet(YES).handler = ^(NSInteger index, NSString *text, BOOL isSelect) {
        NSLog(@"select %ld,text %@",(long)index,text);
    };
    [self addSubview:_tagsView];
    _tagsView.translatesAutoresizingMaskIntoConstraints = NO;
    UIEdgeInsets insets = UIEdgeInsetsMake(50, 10, -10, -10);
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tagsView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:insets.left]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tagsView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:insets.right]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tagsView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:insets.top]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_tagsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:insets.bottom]];
}

@end
