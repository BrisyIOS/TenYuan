//
//  TenController.m
//  TenYuan
//
//  Created by lanou on 15/11/8.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "TenController.h"
#import "Define.h"
#import "TenModel.h"
#import "TenCell.h"
#import "PresentWebViewController.h"

@interface TenController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger _pages;
    NSInteger _channel;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *array;

@end

static NSString *cellIdentifier = @"cell";

@implementation TenController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建segment
    [self createSegment];
    
    // 创建collectionView
    [self createCollectionView];
    
    // 一上来加载一次数据
    [self getTenWithChannel:9 pages:1];
    
}
#pragma mark -- 创建segment --
- (void)createSegment
{
    // 创建segment
    NSArray *titleArray = @[@"精选",@"10元",@"20元",@"30元"];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titleArray];
    segment.frame = CGRectMake(0, 20, kScreenWith, 40);
    segment.tintColor = kMycolor;
    segment.momentary = NO;
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
}
#pragma mark -- 创建collectionView --
- (void)createCollectionView
{
    // 先把之前创建的collectionView移除
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    
    // 初始化pages
    if (self.array) {
        [self.array removeAllObjects];
    }
    self.array = [NSMutableArray array];
    _pages = 1;
    
    // 创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWith/2, kScreenWith/2+120);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith  , kScreenHeight-64-44) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // 注册cell
    [self.collectionView registerClass:[TenCell class] forCellWithReuseIdentifier:cellIdentifier];
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
    [self getTenWithChannel:_channel pages:++_pages];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
}
#pragma mark -- 点击segment的方法 --
- (void)segmentAction:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
            // 创建一个新的collectionView
            [self createCollectionView];
            // 请求数据
            [self getTenWithChannel:9 pages:1];
            _channel = 9;
            break;
        }
        case 1:
        {
            [self createCollectionView];
            [self getTenWithChannel:3 pages:1];
            _channel = 3;
            break;
        }
        case 2:
        {
            [self createCollectionView];
            [self getTenWithChannel:4 pages:1];
            _channel = 4;
            break;
        }
        case 3:
        {
            [self createCollectionView];
            [self getTenWithChannel:5 pages:1];
            _channel = 5;
            break;
        }
        default:
            break;
    }
}
#pragma mark -- 数据请求 --
- (void)getTenWithChannel:(NSInteger)channel pages:(NSInteger)pages
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=getproductlist&v=29&pages=%ld&bc=0&sc=0&sorts=&channel=%ld&ckey=&daynews=&lprice=0&hprice=0&tbclass=0&actid=0&brandid=0&predate=", pages, channel];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            TenModel *model = [[TenModel alloc] init];
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
    TenModel *model = self.array[indexPath.row];
    TenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TenCell alloc] init];
    }
    [cell setModel:model];
    return cell;
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TenModel *model = self.array[indexPath.item];
    PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    [self presentViewController:webVc animated:YES completion:nil];
}
@end








