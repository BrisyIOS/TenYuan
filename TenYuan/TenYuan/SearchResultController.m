//
//  SearchResultController.m
//  TenYuan
//
//  Created by lanou on 15/11/24.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "SearchResultController.h"
#import "Define.h"
#import "SearchResultModel.h"
#import "SearchResultCell.h"
#import "PresentWebViewController.h"

@interface SearchResultController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>
{
    NSInteger _pages;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIWebView *webView;

@end

static NSString *cellIdentifier = @"cell";

@implementation SearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建搜索框
    [self createSearchTF];
    
}

#pragma mark -- 创建collectionView --
- (void)createCollectionView
{
    // 创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWith/2, kScreenWith/2+120);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith  , kScreenHeight-64) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // 注册cell
    [self.collectionView registerClass:[SearchResultCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.collectionView];
    
    // 添加上拉加载和下拉刷新
    [self addRefresh];
}
#pragma mark -- 创建搜索框 --
- (void)createSearchTF
{
    CGFloat height = 30;
    
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
    myView.backgroundColor = kMycolor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 27, height, height);
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    
    // 创建搜索框
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(height+30, 27, myView.width-120, height)];
    self.searchTF.userInteractionEnabled = YES;
    self.searchTF.backgroundColor = [UIColor whiteColor];
    self.searchTF.placeholder = @"🔍搜索商品";
    self.searchTF.clearButtonMode = UITextFieldViewModeAlways;
    
    // 创建搜索的按钮
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.searchBtn.frame = CGRectMake(kScreenWith-50, 27, 50, height);
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [myView addSubview:self.searchBtn];
    [myView addSubview:self.searchTF];
    [myView addSubview:backBtn];
    [self.view addSubview:myView];
    
    // 调出键盘
    [self.searchTF becomeFirstResponder];
    // 设置代理
    self.searchTF.delegate = self;
}
#pragma mark -- 返回的按钮 --
- (void)backBtnAction:(UIButton *)btn
{
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.window cache:YES];
    } completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark -- 搜索的按钮 --
- (void)searchBtnAction:(UIButton *)btn
{
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    self.array = [NSMutableArray array];
    _pages = 1;
    [self createCollectionView];
    [self getTenWithCkey:self.searchTF.text pages:1];
    [self.searchTF resignFirstResponder];
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
    // 将数组中第一次请求的数据删除
    if (_pages != 1) {
        NSInteger temp = self.array.count/_pages;
        NSLog(@"temp == %ld", temp);
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
#pragma mark -- 上拉加载更多 --
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
    [self getTenWithCkey:self.searchTF.text pages:++_pages];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
}
#pragma mark -- 数据请求 --
- (void)getTenWithCkey:(NSString *)ckey pages:(NSInteger)pages
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if ([ckey isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入要搜索的商品" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *key = [ckey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *postString = [NSString stringWithFormat:@"act=getproductlist&v=29&pages=%ld&bc=0&sc=0&sorts=&channel=0&ckey=%@&daynews=&lprice=0&hprice=0&tbclass=0&actid=0&brandid=0&predate=", pages, key];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            SearchResultModel *model = [[SearchResultModel alloc] init];
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
    SearchResultModel *model = self.array[indexPath.row];
    SearchResultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SearchResultCell alloc] init];
    }
    [cell setModel:model];
    return cell;
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchResultModel *model = self.array[indexPath.item];
    PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    [self presentViewController:webVc animated:YES completion:nil];
}
#pragma mark -- 点击return回收键盘 --
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTF resignFirstResponder];
    return YES;
}
@end
