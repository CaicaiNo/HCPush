//
//  HCWebViewController.h
//  HCPush
//
//  Created by gensee on 2020/3/25.
//  Copyright © 2020年 haocaihaocai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HCWebViewController : UIViewController

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) NSURL *url;

@end

NS_ASSUME_NONNULL_END
