//
//  ViewController.m
//  HCPushSettingViewController
//
//  Created by haocaihaocai on 2020/3/16.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "ViewController.h"
#import "HCPushSettingViewController.h"
#import "HCTestCollectionViewController.h"
#import "HCTestTableViewController.h"
#import "HCTestView.h"

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
    HCPushSettingViewController *myvc = [HCPushSettingViewController settingControllerWithContentController:tablevc];
    myvc.alignment = HCBaseSettingAlignmentLeft;
    
    [self presentViewController:myvc animated:YES completion:nil];
}

- (IBAction)pushView:(id)sender {
    HCTestView *tagview = [[HCTestView alloc] init];
    HCPushSettingViewController *myvc = [[HCPushSettingViewController alloc] init];
    myvc.childView = tagview;
    [self presentViewController:myvc animated:YES completion:nil];
}

- (BOOL)shouldAutorotate  {
    return YES;
}

@end
