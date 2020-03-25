//
//  HCWebViewController.m
//  HCPush
//
//  Created by gensee on 2020/3/25.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import "HCWebViewController.h"

@interface HCWebViewController () <WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UINavigationBar *privateBar;

@end

@implementation HCWebViewController

- (UINavigationBar *)privateBar {
    if (!_privateBar) {
        _privateBar = [[UINavigationBar alloc] init];
        //    2、创建navitem装载功能按键
        UINavigationItem *navitem = [[UINavigationItem alloc] initWithTitle:@"Title"];
        //    3、创建左右两个按钮
        UIBarButtonItem *leftbtn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit)];
        UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(finishEdit)];
        //    4、赋予navitem标题
        [navitem setTitle:self.title];
        //    5、push navitem到navbar
        [_privateBar pushNavigationItem:navitem animated:YES];
        //    6、set按钮到navitem
        [navitem setLeftBarButtonItem:leftbtn];
        [navitem setRightBarButtonItem:rightbtn];
        //    7、navbar子视图放到VC上
        _privateBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _privateBar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) configuration:[[WKWebViewConfiguration alloc] init]];
    self.progressView = [[UIProgressView alloc] init];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [self.view addSubview:self.webView];
    [self.webView addSubview:self.progressView];
    
    
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[webview]-0-|" options:0 metrics:nil views:@{@"webview":self.webView}]];
    
    if (self.navigationController != nil) {
        NSString *visualstr = @"V:|-0-[webview]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualstr options:0 metrics:nil views:@{@"webview":self.webView,@"topLayoutGuide":self.topLayoutGuide}]];
    }else {
        [self.view addSubview:self.privateBar];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.privateBar attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        NSString *visualstr = @"V:|-20-[navbar(44)]-0-[webview]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualstr options:0 metrics:nil views:@{@"webview":self.webView,@"topLayoutGuide":self.topLayoutGuide,@"navbar":self.privateBar}]];
    }
    
    
    
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.progressView.progress = 0.1;
    
    [self requestURL];
}

- (void)finishEdit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestURL {
    if (self.url) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.progressView.frame = CGRectMake(0, 0, self.webView.bounds.size.width, 2);
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSNumber *number = change[NSKeyValueChangeNewKey];
        if (number) {
            float newProgress = number.floatValue;
            if (newProgress <= 0.01) {
                self.progressView.hidden = YES;
            }else if (newProgress >= 1.0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.progressView.hidden = YES;
                });
            }else {
                self.progressView.progress = newProgress;
                self.progressView.hidden = NO;
            }
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        NSString *str = change[NSKeyValueChangeNewKey];
        if (str) {
            self.title = str;
            self.privateBar.topItem.title = str;
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    // 判断服务器采用的验证方法
    if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
        // 如果没有错误的情况下 创建一个凭证，并使用证书
        if (challenge.previousFailureCount == 0) {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }else {
            // 验证失败，取消本次验证
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    }else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        
    }
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
