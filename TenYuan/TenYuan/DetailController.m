//
//  DetailController.m
//  TenYuan
//
//  Created by lanou on 15/12/2.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "DetailController.h"
#import "Define.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "TwoCell.h"
#import "PresentWebViewController.h"

@interface DetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger _pages;
    NSInteger _actid;
}

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

static NSString *cellIdentifierVer = @"collectionCell";
static NSString *firstIdentifier = @"first";

@implementation DetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义navigationItem.titleView
    [self createDiySubViews];
    
    // 创建collectionView
    [self createVerCollectionView];
    
    // 一上来显示精选
    [self getTenWithPages:1 actid:self.actid];
    
}
#pragma mark -- 自定义navigationItem.titleView --
- (void)createDiySubViews
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 55)];
    topView.backgroundColor = kMycolor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, 20, 50, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backBtn];
    
    // 标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWith-200)/2, 20, 200, 35)];
    title.text = self.name;
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20];
    [topView addSubview:title];
    [self.view addSubview:topView];
}
#pragma mark -- 返回 --
- (void)back:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 创建collectionView --
- (void)createVerCollectionView
{
    // 先把之前创建的collectionView移除
    if (self.collectionView) {
        [self.collectionView removeFromSuperview];
    }
    // 初始化数组和页码
    self.array = [NSMutableArray array];
    _pages = 1;
    
    // 先创建一个布局对象
    UICollectionViewFlowLayout *verLayout = [[UICollectionViewFlowLayout alloc] init];
    //CGFloat width = kScreenWith / 2;
    //verLayout.itemSize = CGSizeMake(width, width+120);
    verLayout.minimumInteritemSpacing = 0;
    verLayout.minimumLineSpacing = 0;
    // 创建一个集合视图对象
    // UICollectionViewLayout是集合视图一部分的布局方式，控制集合视图整体的上下左右的边距以及视图的行和列边距
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 55, kScreenWith, kScreenHeight-55) collectionViewLayout:verLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    // 注册cell
    [self.collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:cellIdentifierVer];
    [self.collectionView registerClass:[TwoCell class] forCellWithReuseIdentifier:firstIdentifier];
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
        [self.array removeObjectsInRange:NSMakeRange(40, self.array.count+1-41)];
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
    [self getTenWithPages:++_pages actid:self.actid];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
}
#pragma mark -- 数据请求解析 --
- (void)getTenWithPages:(NSInteger)pages actid:(NSInteger)actid
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=getproductlist&v=29&pages=%ld&bc=0&sc=0&sorts=&channel=0&ckey=&daynews=&lprice=0&hprice=0&tbclass=0&actid=%ld&brandid=0&predate=", pages, actid];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            HomeModel *model = [[HomeModel alloc] init];
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
    return self.array.count+1;
}
#pragma mark -- 返回cell --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TwoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[TwoCell alloc] init];
        }
        cell.imgView.image = [UIImage imageNamed:self.catName];
        return cell;
    } else {
        HomeModel *model = self.array[indexPath.item-1];
        HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierVer forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeCell alloc] init];
        }
        [cell setModel:model];
        return cell;
    }
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    HomeModel *model = self.array[indexPath.item-1];
    PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    [self presentViewController:webVc animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 返回高度 --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(kScreenWith, kScreenWith*1.24*0.3);
    } else {
        return CGSizeMake(kScreenWith/2, kScreenWith/2+120);
    }
}

@end
