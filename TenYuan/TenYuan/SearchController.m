//
//  SearchController.m
//  TenYuan
//
//  Created by lanou on 15/11/24.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "SearchController.h"
#import "Define.h"
#import "SearchModel.h"
#import "SearchCollectionViewCell.h"
#import "PresentWebViewController.h"

@interface SearchController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL _isClick;// 用来记录价格的排序
    NSInteger _pages;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSString *sorts;


@end

static NSString *cellIdentifier = @"cell";

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建topView grayView backButton
    [self createSomeViews];
    
    // 创建筛选的Button
    [self createSearchButton];
    
    // 创建collectionView
    [self createCollectionView];
    
    // 开始加载
    [self startLoading];
    
}
#pragma mark -- 一上来加载默认的，字体红色 --
- (void)startLoading
{
    [self getResultWithBc:self.bc sc:self.sc sorts:@"" channel:self.channel daynews:self.daynews pages:1];
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    [self changeColorWithButton:btn];
}
#pragma mark -- 创建topView grayView backButton --
- (void)createSomeViews
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 55)];
    topView.backgroundColor = kMycolor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 50, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWith-100)/2, 20, 100, 35)];
    title.text = self.name;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    [topView addSubview:title];
    [self.view addSubview:topView];
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, kScreenWith, 44)];
    grayView.backgroundColor = [UIColor grayColor];
    grayView.alpha = 0.3;
    [self.view addSubview:grayView];
}
#pragma mark -- 创建collectionView --
- (void)createCollectionView
{
    // 先把之前的collectionView和数组删除
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    if (self.array) {
        [self.array removeAllObjects];
    }
    
    // 初始化数组和页码
    self.array = [NSMutableArray array];
    _pages = 1;
    // 创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWith/2, kScreenWith/2+120);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    // 创建collectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+30, kScreenWith  , kScreenHeight-64-30) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // 注册cell
    [self.collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
    // 添加上拉加载更多和下拉刷新
    [self addRefresh];
}
#pragma mark -- 添加上拉加载和下拉刷新 --
- (void)addRefresh
{
    // 添加下拉刷新
    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    
    // 添加上拉加载更多
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
}
#pragma mark -- 下拉刷新 --
- (void)headerAction
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 结束刷新
        [self.collectionView.header endRefreshing];
        return;
    }
    // 将数组中的数据全部删除
    if (_pages != 1) {
        // 删除下标是39之后的所有元素
        [self.array removeObjectsInRange:NSMakeRange(39, self.array.count-40)];
        // 刷新一下界面
        [self.collectionView reloadData];
    }
    // 结束刷新
    [self.collectionView.header endRefreshing];
    // 将pages置成1
    _pages = 1;
}
#pragma mark -- 下拉加载更多 --
- (void)footerAction
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 结束刷新
        [self.collectionView.footer endRefreshing];
        return;
    }
    // 请求下一页的内容先让pages加1
    [self getResultWithBc:self.bc sc:self.sc sorts:self.sorts channel:self.channel daynews:self.daynews pages:++_pages];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
}

#pragma mark -- 创建筛选的button --
- (void)createSearchButton
{
    NSArray *titleArray = @[@"默认",@"销量",@"价格⬇︎",@"最新"];
    NSInteger num = 0;
    for (int i = 0; i < 4; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + i * (kScreenWith - 20)/4, 60, (kScreenWith - 20)/4, 30);
        button.layer.borderWidth = 0.5;// Button边框的宽度
        button.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.6].CGColor;// Button边框的颜色
        button.tag = 100 + num++;// 给Button一个tag值
        button.layer.cornerRadius = 3;// 设置圆角
        button.adjustsImageWhenHighlighted = NO;// 去掉点击时变灰色的效果
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];// 添加一个Action
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        if (i == 2) {
            [button setTitle:@"价格⬆︎" forState:UIControlStateSelected];
        }
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:button];
    }
}
#pragma nark -- 返回的按钮 --
- (void)backBtnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -- 点击上面分类筛选的Button --
- (void)buttonAction:(UIButton *)btn
{
    // 判断点击的是哪一个Button
    switch (btn.tag) {
        case 100:// 默认
        {
            // 创建一个新的collectionView
            [self createCollectionView];
            // 改变Button上字体的颜色
            [self changeColorWithButton:btn];
            // 数据请求
            [self getResultWithBc:self.bc sc:self.sc sorts:@"" channel:self.channel daynews:self.daynews pages:1];
            self.sorts = @"";
            break;
        }
        case 101:// 销量
        {
            [self createCollectionView];
            [self changeColorWithButton:btn];
            [self getResultWithBc:self.bc sc:self.sc sorts:@"sale2l" channel:self.channel daynews:self.daynews pages:1];
            self.sorts = @"sale2l";
            break;
        }
        case 102:// 价格
        {
            [self createCollectionView];
            [self changeColorWithButton:btn];
            if (_isClick) {
                [self getResultWithBc:self.bc sc:self.sc sorts:@"ph2l" channel:self.channel daynews:self.daynews pages:1];
                self.sorts = @"ph2l";
                btn.selected = NO;
                _isClick = NO;
            } else {
                [self createCollectionView];
                [self getResultWithBc:self.bc sc:self.sc sorts:@"pl2h" channel:self.channel daynews:self.daynews pages:1];
                self.sorts = @"pl2h";
                btn.selected = YES;
                _isClick = YES;
            }
            break;
        }
        case 103:// 最新
        {
            [self createCollectionView];
            [self changeColorWithButton:btn];
            [self getResultWithBc:self.bc sc:self.sc sorts:@"new" channel:0 daynews:self.daynews pages:1];
            self.sorts = @"new";
            break;
        }
        default:
            break;
    }
}
#pragma mark -- 改变Button上字体颜色的方法 --
- (void)changeColorWithButton:(UIButton *)btn
{
    for (int i = 0; i < 4; i++) {
        UIButton *button = self.view.subviews[i+2];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn setTitleColor:kMycolor forState:UIControlStateNormal];
}
#pragma mark -- 数据请求 --
- (void)getResultWithBc:(NSInteger)bc sc:(NSInteger)sc sorts:(NSString *)sorts channel:(NSInteger)channel daynews:(NSString *)daynews pages:(NSInteger)pages
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=getproductlist&v=29&pages=%ld&bc=%ld&sc=%ld&sorts=%@&channel=%ld&ckey=&daynews=%@&lprice=0&hprice=0&tbclass=0&actid=0&brandid=0&predate=", pages, bc, sc, sorts, channel, daynews];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        for (NSDictionary *rowsDic in dic[@"rows"]) {
            SearchModel *model = [[SearchModel alloc] init];
            [model setValuesForKeysWithDictionary:rowsDic];
            [self.array addObject:model];
        }
        // 回到主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
    }];
    [dataTask resume];
}
#pragma mark -- 返回Item个数 --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
#pragma mark -- 返回Item --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SearchModel *model = self.array[indexPath.row];
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SearchCollectionViewCell alloc] init];
    }
    [cell setModel:model];
    return cell;
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchModel *model = self.array[indexPath.item];
    PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    [self presentViewController:webVc animated:YES completion:nil];
}

@end
