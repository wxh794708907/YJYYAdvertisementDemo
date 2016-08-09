//
//  YJYYWebViewController.m
//  YJYYAdvertisementDemo
//
//  Created by 遇见远洋 on 16/8/9.
//  Copyright © 2016年 遇见远洋. All rights reserved.
//

#import "YJYYWebViewController.h"

@interface YJYYWebViewController ()
@property (nonatomic, strong) UIWebView *webView;


@end

@implementation YJYYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我是广告";
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jianshu.com/p/b2f948bc07f4"]]];
    [self.view addSubview:self.webView];
}
@end



@implementation UIViewController (YJYYPublic)
- (UINavigationController*)YJYY_navigationController
{
    UINavigationController* nav = nil;
    if ([self isKindOfClass:[UINavigationController class]]) {
        nav = (id)self;
    }
    else {
        if ([self isKindOfClass:[UITabBarController class]]) {
            nav = [((UITabBarController*)self).selectedViewController YJYY_navigationController];
        }
        else {
            nav = self.navigationController;
        }
    }
    return nav;
}


@end
