# HCPushSettingViewController
![language](https://img.shields.io/badge/language-Object--C-brightgreen)
![Version](https://img.shields.io/badge/Version-1.1.0-brightgreen)
![Platform](https://img.shields.io/badge/Platform-iOS-brightgreen)

用于项目使用的方便的左侧或者右侧的弹出视图，自定义ViewController的逻辑独立

https://github.com/CaicaiNo/HCPush.git

效果展示：

![](https://img-blog.csdnimg.cn/20200316210411133.gif)
# CocoaPods
```c
pod 'HCPushSettingViewController'
```
## 问题处理
1. `[!] Unable to find a specification for HCPushSettingViewController`

调用pod repo update更新pod库

2. `[!] CDN: trunk Repo update failed`

podfile文件中指定source源为master 

```c
source 'https://github.com/CocoaPods/Specs.git'
```

# Requirements

 - iOS 8.0 or higher
 - ARC
 - Xcode 8.0 or higher

# Usage
## 链式调用
1. 界面推出
```c
//创建内容vc
HCTestTableViewController *tablevc = [[HCTestTableViewController alloc] init];
//创建push vc
HCPushSettingViewController *myvc = HCPush.create.childvc(tablevc).align(HCPushSettingAlignmentLeft).done;
//推出
[self presentViewController:myvc animated:YES completion:nil];
```
2. 自定义视图显示
```c
    HCAlertAction *action = HCAlertAction.create.tlt(@"确定").optBtn(^(UIButton *button) {
        button.backgroundColor = [UIColor colorWithRed:229/255.0 green:62/255.0 blue:54/255.0 alpha:1.0];
        button.layer.cornerRadius = 22.f;
    }).action(^(HCAlertAction *action) {
        NSLog(@"click action 1");
    });
    
    HCAlertAction *action2 = HCAlertAction.create.tlt(@"取消").optBtn(^(UIButton *button) {
        button.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [button setTitleColor:[UIColor colorWithRed:92/255.0 green:92/255.0 blue:92/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.layer.cornerRadius = 22.f;
    }).action(^(HCAlertAction *action) {
        NSLog(@"click action 2");
    });
    
    
    NSString *colorStr = @"《隐私政策》";
    NSString *originStr = @"为了更好地保障您的个人权益，请认真阅读《隐私政策》的全部内容，同意并接受全部条款后开始使用我们的产品和服务。如选择不同意，将无法使用我们的产品和服务，并退出应用。";
    
    NSMutableAttributedString *mutaStr = [[NSMutableAttributedString alloc] initWithString:originStr attributes:[NSDictionary dictionaryWithObjects:@[[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]] forKeys:@[NSForegroundColorAttributeName]]];
    
    [mutaStr setAttributes:[NSDictionary dictionaryWithObjects:@[[NSURL URLWithString:@"http://www.baidu.com"],[UIColor colorWithRed:229/255.0 green:62/255.0 blue:51/255.0 alpha:1]] forKeys:@[NSLinkAttributeName,NSForegroundColorAttributeName]] range:[originStr rangeOfString:colorStr]];
    
    [mutaStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang SC" size: 14]
                    range:NSMakeRange(0, originStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing = 5;
    [mutaStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle
                    range:NSMakeRange(0, originStr.length)];
    [mutaStr addAttribute:NSKernAttributeName value:@(0.5)
                    range:NSMakeRange(0, originStr.length)];
    
    HCAlertView *alert = HCAlertView.create.title([[NSAttributedString alloc] initWithString:@"隐私政策"]).attr(mutaStr).add(action).add(action2).urlAction(^(NSURL *url) {
        NSLog(@"click url %@",url);
    }).linkColor([UIColor colorWithRed:229/255.0 green:62/255.0 blue:51/255.0 alpha:1]);
    
    HCPushSettingViewController *myvc = HCPush.create.align(HCPushSettingAlignmentCenter).tapDismiss(NO).transition(HCBaseTransitionAnimationDropDown).ctSize(CGSizeMake(315, 350)).childview(alert).bgColor([UIColor colorWithRed:26/255.f green:26/255.f blue:26/255.f alpha:0.5]).done;

    [self presentViewController:myvc animated:YES completion:nil];
```

详细见`demo`
## 非链式调用
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
typedef NS_ENUM(NSInteger, HCPushSettingAlignment) {
    HCPushSettingAlignmentRight, //view position is right
    HCPushSettingAlignmentLeft, //view postion is left
    HCPushSettingAlignmentCenter, //view postion is center
    HCPushSettingAlignmentTop, //view postion is top
    HCPushSettingAlignmentBottom, //view postion is top
};


typedef NS_ENUM(NSInteger, HCBaseTransitionAnimation) {
    HCBaseTransitionAnimationSlideDirectly = 0,
    HCBaseTransitionAnimationFade,
    HCBaseTransitionAnimationScaleFade,
    HCBaseTransitionAnimationDropDown,
    HCBaseTransitionAnimationCustom
};

@interface HCBaseViewController : UIViewController

///Content view
@property (nonatomic, strong, readonly) UIView *hcContentView;

///Content view background Color
@property (nonatomic, strong) UIColor *hcContentViewBackgroundColor;

///hcContentView`s size, default is {300,MAXFLOAT},MAXFLOAT means will fill screen height
@property (nonatomic, assign) CGSize hcContentSize;

///Content EdgeInset ,Only Top and Bottom value is validate,left and right will be ignored. Default is UIEdgeInsetsZero
@property (nonatomic, assign) UIEdgeInsets contentInset;

///The final view postion,default is Right
@property (nonatomic, assign) HCPushSettingAlignment alignment;

///transition animation
@property (nonatomic, assign) HCBaseTransitionAnimation transitionAnimation;

///custom transition class
@property (nonatomic, assign) Class transitionAnimationClass;

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
