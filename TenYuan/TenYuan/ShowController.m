//
//  ShowController.m
//  TenYuan
//
//  Created by lanou on 15/11/23.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "ShowController.h"
#import "SearchController.h"
#import "SearchResultController.h"
#import "Define.h"

@interface ShowController ()

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ShowController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建搜索框的label
    [self creatSearchLabel];
    
    // 创建Button
    [self creatButton];
    
}
#pragma mark -- 创建搜索框的方法 --
- (void)creatSearchLabel
{
    CGFloat height = 30;
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith-60, 30)];
    // 创建返回的按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.frame = CGRectMake(0, 0, height, height);
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:self.backBtn];
    
    // 创建轻拍手势
    //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    // 创建商品标题
    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(height+10, 0, myView.width-height, height)];
    //[self.searchLabel addGestureRecognizer:tap];
    self.searchLabel.userInteractionEnabled = YES;
    //self.searchLabel.backgroundColor = [UIColor whiteColor];
    //self.searchLabel.text = @"🔍搜索商品";
    self.searchLabel.text = @"更多";
    self.searchLabel.textAlignment = NSTextAlignmentCenter;
    self.searchLabel.font = [UIFont boldSystemFontOfSize:20];
    self.searchLabel.textColor = [UIColor whiteColor];
    //self.searchLabel.textColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.5];
    [myView addSubview:self.searchLabel];
    
    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithCustomView:myView];
    self.navigationItem.leftBarButtonItem = backBarItem;
}
#pragma mark -- 轻拍手势tapAction --
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    SearchResultController *searchResultVc = [[SearchResultController alloc] init];
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view.window cache:YES];
    } completion:nil];
    [self presentViewController:searchResultVc animated:NO completion:nil];
}
#pragma mark -- 返回的按钮 --
- (void)backBtnAction:(UIButton *)btnr
{
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    } completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建Button --
- (void)creatButton
{
    // 装图片的名字的数组
    NSArray *array = @[@"女装",@"母婴",@"美食",@"文体",@"十元包邮",@"男装",@"鞋包",@"数码家电",@"中老年",@"今日更新",@"居家",@"内衣",@"美妆个护",@"配饰",@"全部"];
    NSInteger num = 0;
    
    // 循环创建Button
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 5; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(kScreenWith/3*i, kScreenWith/3/1.25*(j+1), kScreenWith/3, kScreenWith/3/1.25);
            button.tag = 100 + num;
            [button setImage:[UIImage imageNamed:array[num++]] forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted = NO;
            button.layer.borderWidth = 0.5;
            button.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];
        }
    }

}
#pragma mark -- Button触发方法 --
- (void)buttonAction:(UIButton *)btn
{
    // 根据Button的tag值判断点击的是哪一个Button
    switch (btn.tag) {
        case 100:
        {
            //NSLog(@"%ld", btn.tag);//女装
            [self passToSearchVcWithBc:1 sc:0 channel:0 daynews:@""];
            break;
        }
        case 101:
        {
            //NSLog(@"%ld", btn.tag);//母婴
            [self passToSearchVcWithBc:4 sc:0 channel:0 daynews:@""];
            break;
        }
        case 102:
        {
            //NSLog(@"%ld", btn.tag);//美食
            [self passToSearchVcWithBc:7 sc:0 channel:0 daynews:@""];
            break;
        }
        case 103:
        {
            //NSLog(@"%ld", btn.tag);//文体
            [self passToSearchVcWithBc:10 sc:0 channel:0 daynews:@""];
            break;
        }
        case 104:
        {
            //NSLog(@"%ld", btn.tag);//十元包邮
            [self passToSearchVcWithBc:0 sc:0 channel:3 daynews:@""];
            break;
        }
        case 105:
        {
            //NSLog(@"%ld", btn.tag);//男装
            [self passToSearchVcWithBc:2 sc:0 channel:0 daynews:@""];
            break;
        }
        case 106:
        {
            //NSLog(@"%ld", btn.tag);//鞋包
            [self passToSearchVcWithBc:5 sc:0 channel:0 daynews:@""];
            break;
        }
        case 107:
        {
            //NSLog(@"%ld", btn.tag);//数码家电
            [self passToSearchVcWithBc:8 sc:0 channel:0 daynews:@""];
            break;
        }
        case 108:
        {
            //NSLog(@"%ld", btn.tag);//中老年
            [self passToSearchVcWithBc:1 sc:16 channel:0 daynews:@""];
            break;
        }
        case 109:
        {
            //NSLog(@"%ld", btn.tag);//今日更新
            [self passToSearchVcWithBc:0 sc:0 channel:0 daynews:@"1"];
            break;
        }
        case 110:
        {
            //NSLog(@"%ld", btn.tag);//居家
            [self passToSearchVcWithBc:3 sc:0 channel:0 daynews:@""];
            break;
        }
        case 111:
        {
            //NSLog(@"%ld", btn.tag);//内衣
            [self passToSearchVcWithBc:1 sc:13 channel:0 daynews:@""];
            break;
        }
        case 112:
        {
            //NSLog(@"%ld", btn.tag);//美妆个护
            [self passToSearchVcWithBc:9 sc:0 channel:0 daynews:@""];
            break;
        }
        case 113:
        {
            //NSLog(@"%ld", btn.tag);//配饰
            [self passToSearchVcWithBc:6 sc:0 channel:0 daynews:@""];
            break;
        }
        case 114:
        {
            //NSLog(@"%ld", btn.tag);//全部
            [self passToSearchVcWithBc:0 sc:0 channel:0 daynews:@""];
            break;
        }
        default:
            break;
    }
    
}
#pragma mark -- 创建跳转传值到searchVc --
- (void)passToSearchVcWithBc:(NSInteger)bc sc:(NSInteger)sc channel:(NSInteger)channel daynews:(NSString *)daynews
{
    SearchController *searchVc = [[SearchController alloc] init];
    searchVc.bc = bc;
    searchVc.sc = sc;
    searchVc.channel = channel;
    searchVc.daynews = daynews;
    [self presentViewController:searchVc animated:NO completion:nil];
}

@end
