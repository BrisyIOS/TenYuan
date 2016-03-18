//
//  PresentWebViewController.m
//  TenYuan
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "PresentWebViewController.h"
#import "Define.h"

@interface PresentWebViewController ()

@property (nonatomic, strong) UIView *dismissView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIButton *shareBtn;

@end

@implementation PresentWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建上面的标题的View
    [self createTitleView];
    
    // 创建webView
    [self createWebView];
    
    // 判断网络
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
}
#pragma mark -- 创建webview --
- (void)createWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith, kScreenHeight-64)];
    webView.scrollView.bounces = NO;// 关闭边界回弹
    NSURL *url = [NSURL URLWithString:self.ProductUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}
#pragma mark -- 创建上面的标题的View --
- (void)createTitleView
{
    CGFloat y = 27;
    CGFloat height = 30;
    // 创建返回的View
    self.dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
    self.dismissView.backgroundColor = kMycolor;
    
    // 创建返回的按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(15, y, height, height);
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissView addSubview:self.backBtn];
    
    // 创建商品标题
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(self.backBtn.width+15, y, kScreenWith-height*2-15, height)];
    self.name.text = self.product;
    self.name.textColor = [UIColor whiteColor];
    [self.dismissView addSubview:self.name];
    // 创建分享的按钮
//    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.shareBtn.frame = CGRectMake(self.backBtn.width+self.name.width, y, height, height);
//    [self.shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
//    [self.shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.dismissView addSubview:self.shareBtn];
    // 添加到dismissView上
    [self.view addSubview:self.dismissView];
}
#pragma mark -- 返回的按钮 --
- (void)backBtnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 分享的按钮 --
- (void)shareBtnAction:(UIButton *)btn
{
    NSLog(@"分享");
}

@end
