//
//  PushWebViewController.m
//  TenYuan
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "PushWebViewController.h"
#import "Define.h"

@interface PushWebViewController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation PushWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义navigationBar
    [self createNavigationBar];
    
    // 创建webview
    [self createWebView];
    
    // 判断网络
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
}


#pragma mark -- 自定义navigationBar --
- (void)createNavigationBar
{
    CGFloat height = 30;
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 30)];
    // 创建返回的按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, height, height);
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:self.backBtn];
    
    // 创建商品标题
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(height, 0, myView.width-height, height)];
    self.name.text = self.product;
    self.name.textColor = [UIColor whiteColor];
    [myView addSubview:self.name];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:myView];
    self.navigationItem.leftBarButtonItem = backBarItem;
    
    // 创建分享的按钮
//    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareBtn.frame = CGRectMake(0, 0, height, height);
//    [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    [self.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *shareBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareBtn];
//    self.navigationItem.rightBarButtonItem = shareBarItem;
    
}
#pragma mark -- 创建webView --
- (void)createWebView
{
    // 判断是从哪个页面跳过来的
    if (self.isHome) {
        // 创建webView
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight)];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight-64)];
    }
    
    self.webView.scrollView.bounces = NO;// 关闭边界回弹
    NSURL *url = [NSURL URLWithString:self.ProductUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}
#pragma mark -- 返回的按钮 --
- (void)backBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark -- 分享的按钮 --
- (void)shareBtnAction:(UIButton *)btn
{
    NSLog(@"分享");
}


@end
