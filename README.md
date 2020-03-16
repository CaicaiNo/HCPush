# HCPushSettingViewController
[![language](https://img.shields.io/badge/language-Object--C-brightgreen)
[![Version](https://img.shields.io/badge/Version-1.0-brightgreen)
[![Platform](https://img.shields.io/badge/Platform-iOS-brightgreen)

用于项目使用的方便的左侧或者右侧的弹出视图，自定义ViewController的逻辑独立

效果展示：

![](https://img-blog.csdnimg.cn/20200316210411133.gif)
# CocoaPods
```c
pod 'HCPushSettingViewController'
```
# Requirements

 - iOS 8.0 or higher
 - ARC
 - Xcode 8.0 or higher

# Usage

1. 创建一个视图（你需要显示的内容）
```c
HCTestTableViewController *tablevc = [[HCTestTableViewController alloc] init];
```

2. 创建`HCPushSettingViewController`，并将其关联，然后使用`present`方法推出
```c
HCPushSettingViewController *myvc = [HCPushSettingViewController settingControllerWithContentController:tablevc];
myvc.alignment = HCBaseSettingAlignmentLeft;
[self presentViewController:myvc animated:YES completion:nil];
```
3. 配置窗口大小以及各个参数
```c
//设置视图方向 - 左侧显示
myvc.alignment = HCBaseSettingAlignmentLeft;
//内容大小为 300x500 MAXFLOAT表示铺满
myvc.hcContentSize = CGSizeMake(300, 500);
//设置边距缩进
myvc.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
//设置背景色
myvc.backgroundColor = [UIColor colorWithRed:26/255.f green:26/255.f blue:26/255.f alpha:0.5];
//打开跳转动画 - 不打开则界面直接显示
myvc.isTransitionAnimate = YES;
//点击背景隐藏手势启用
myvc.backgoundTapDismissEnable = YES
```
4. 更多查看头文件`HCBaseSettingViewController.h`
```c
///Content view background Color
@property (nonatomic, strong) UIColor *hcContentViewBackgroundColor;

///hcContentView`s size, default is {300,MAXFLOAT},MAXFLOAT means will fill screen height
@property (nonatomic, assign) CGSize hcContentSize;

///Content EdgeInset ,Only Top and Bottom value is validate,left and right will be ignored. Default is UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets contentInset;

///The final view postion,default is Right
@property (nonatomic, assign) HCBaseSettingAlignment alignment;

///Transition is animate,default is YES
@property (nonatomic, assign) BOOL isTransitionAnimate;

///If backgroundView not set,the value will effect backgroundView`s color
@property (nonatomic, strong) UIColor *backgroundColor;

///backgroundView
@property (nonatomic, strong) UIView *backgroundView;

///Tag backgoundView will cause ViewController dismiss
@property (nonatomic, assign) BOOL backgoundTapDismissEnable;

///dismiss controller completed block
@property (nonatomic, copy) void (^dismissComplete)(void);
```
# Contact
如果请问题，请联系我，或者提交bug
