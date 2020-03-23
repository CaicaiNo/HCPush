//
//  ViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "ViewController.h"
#import "HCPush.h"
#import "HCTestCollectionViewController.h"
#import "HCTestTableViewController.h"
#import "HCTestView.h"
#import "HCAlertView.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
  
}

- (IBAction)pushFromRight:(id)sender {
    HCTestCollectionViewController *hvTest = [[HCTestCollectionViewController alloc] init];
    
    HCPushSettingViewController *myvc = [HCPushSettingViewController settingControllerWithContentController:hvTest];
//    myvc.hcContentSize = CGSizeMake(300, 500);
//    myvc.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    myvc.backgroundColor = [UIColor colorWithRed:26/255.f green:26/255.f blue:26/255.f alpha:0.5];
    [self presentViewController:myvc animated:YES completion:nil];
}


- (IBAction)pushFromLeft:(id)sender {
    HCTestTableViewController *tablevc = [[HCTestTableViewController alloc] init];
    HCPushSettingViewController *myvc = HCPush.create.childvc(tablevc).align(HCPushSettingAlignmentLeft).done;
    /*
    
    HCPushSettingViewController *myvc = [HCPushSettingViewController settingControllerWithContentController:tablevc];
    myvc.alignment = HCPushSettingAlignmentLeft;
    */
    [self presentViewController:myvc animated:YES completion:nil];
}

- (IBAction)pushView:(id)sender {
    HCTestView *tagview = [[HCTestView alloc] init];
    HCPushSettingViewController *myvc = [[HCPushSettingViewController alloc] init];
    myvc.childView = tagview;
    [self presentViewController:myvc animated:YES completion:nil];
}
- (IBAction)pushFromCenter:(id)sender {
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
        exit(0);
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
    /*
    HCPushSettingViewController *myvc = [[HCPushSettingViewController alloc] init];
    myvc.alignment = HCPushSettingAlignmentCenter;
    myvc.backgoundTapDismissEnable = NO;
    myvc.transitionAnimation = HCBaseTransitionAnimationDropDown;
    myvc.hcContentSize = CGSizeMake(315, 350);
    myvc.childView = alert;
    myvc.backgroundColor = [UIColor colorWithRed:26/255.f green:26/255.f blue:26/255.f alpha:0.5];
     */
    [self presentViewController:myvc animated:YES completion:nil];
    
}

- (BOOL)shouldAutorotate  {
    return YES;
}

@end
