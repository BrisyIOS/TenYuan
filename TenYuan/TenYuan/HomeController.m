//
//  HomeController.m
//  TenYuan
//
//  Created by lanou on 15/11/30.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "HomeController.h"
#import "HomeUpCell.h"
#import "HomeCell.h"
#import "HomeModel.h"
#import "ShowController.h"
#import "Define.h"
#import "SearchController.h"
#import "BrandSaleController.h"
#import "PushWebViewController.h"
#import "DetailController.h"

@interface HomeController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,downTapDelegate,downLastSaleDelegate,midMoreDelegate,upTapDelegate>
{
    NSInteger _pages;
}
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *oneCell = @"oneCell";
static NSString *twoCell = @"twoCell";

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建搜索的button和分享的button还有标题
    [self createSearchBtnAndShareBtn];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight) collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[HomeUpCell class] forCellWithReuseIdentifier:oneCell];
    [self.collectionView registerClass:[HomeCell class] forCellWithReuseIdentifier:twoCell];
    
    [self.view addSubview:self.collectionView];
    
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 添加上拉加载和下拉刷新
        [self addRefresh];
        return;
    }
    
    // 初始化数组
    self.array = [NSMutableArray array];
    _pages = 1;
    
    // 数据请求
    [self getHomeWithPage:1];
    
    // 添加上拉加载和下拉刷新
    [self addRefresh];
    
}
#pragma mark -- 实现upTap协议 --
- (void)upTapDelegateWithActid:(NSInteger)actid catName:(NSString *)catName tName:(NSString *)tName
{
    self.hidesBottomBarWhenPushed = YES;
    DetailController *detailVc = [[DetailController alloc] init];
    detailVc.catName = catName;
    detailVc.actid = actid;
    detailVc.name = tName;
    [self presentViewController:detailVc animated:YES completion:nil];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 实现今日更新、手机周边、美食、美妆的代理方法 --
- (void)downTapDelegatePassToSearchVcWithBc:(NSInteger)bc sc:(NSInteger)sc channel:(NSInteger)channel daynews:(NSString *)daynews actid:(NSInteger)actid detaiName:(NSString *)detailName
{
    SearchController *searchVc = [[SearchController alloc] init];
    searchVc.bc = bc;
    searchVc.sc = sc;
    searchVc.actid = actid;
    searchVc.channel = channel;
    searchVc.daynews = daynews;
    searchVc.name = detailName;
    [self presentViewController:searchVc animated:NO completion:nil];
}
#pragma mark -- 实现最后疯抢的代理方法 --
- (void)downLastSale
{
    BrandSaleController *brandSaleVc = [[BrandSaleController alloc] init];
    brandSaleVc.isHome = YES;
    [self.navigationController pushViewController:brandSaleVc animated:NO];
}
#pragma mark -- 实现更多地代理方法 --
- (void)midMoreDelegate
{
    self.hidesBottomBarWhenPushed = YES;
    ShowController *showVc = [[ShowController alloc] init];
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    } completion:nil];
    [self.navigationController pushViewController:showVc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 创建搜索的button和分享的button还有标题 --
- (void)createSearchBtnAndShareBtn
{
    // 搜索的按钮
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.leftBarButtonItem = searchBarButtonItem;
    // 签到的按钮
//    UIButton *signButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    signButton.frame = CGRectMake(0, 0, 30, 30);
//    [signButton setImage:[UIImage imageNamed:@"sign"] forState:UIControlStateNormal];
//    [signButton addTarget:self action:@selector(signBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *signBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:signButton];
//    self.navigationItem.rightBarButtonItem = signBarButtonItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    titleLabel.text = @"十元包邮";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];//212 24 148
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = kMycolor;
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
        [self.array removeObjectsInRange:NSMakeRange(40, self.array.count-40)];
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
    [self getHomeWithPage:++_pages];
    // 结束刷新
    [self.collectionView.footer endRefreshing];
}
#pragma mark -- 搜索的Button的方法 --
- (void)searchBtnAction:(UIButton *)btn
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    ShowController *showVc = [[ShowController alloc] init];
    [UIView animateWithDuration:1 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    } completion:nil];
    [self.navigationController pushViewController:showVc animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark -- 签到的Button的方法 --
- (void)signBtnAction:(UIButton *)btn
{
    NSLog(@"签到");
}
#pragma mark -- 数据请求解析 --
- (void)getHomeWithPage:(NSInteger)page
{
    // post请求
    // 获取当前的日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";// 日期格式
    formatter.timeZone = [NSTimeZone systemTimeZone];// 给定系统所在时区
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *s = @"+11%3A18%3A44";
    NSString *postString = [NSString stringWithFormat:@"act=getproductlist&v=28&pages=%ld&bc=0&sc=0&sorts=&channel=0&ckey=&daynews=&lprice=0&hprice=0&tbclass=0&actid=0&brandid=0&predate=%@%@", (long)page, date, s];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    // 创建数组接收请求的数据
    
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (![[NetworkState shareInstance] reachability]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        
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
#pragma mark -- 返回cell的个数 --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count+1;
}
#pragma mark -- 返回cell --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        HomeUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:oneCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.downTapDelegate = self;
        cell.downLastSaleDelegate = self;
        cell.midMoreDelegate = self;
        cell.upTapDelegate = self;
        return cell;
        
    } else {
        HomeModel *model = self.array[indexPath.row-1];
        HomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:twoCell forIndexPath:indexPath];
        [cell setModel:model];
        return cell;
    }
}
#pragma mark -- 返回cell的高度 --
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return CGSizeMake(kScreenWith, kScreenWith*1.24);
    } else {
        
        return CGSizeMake(kScreenWith/2, kScreenWith/2+120);
    }
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 点击第一个cell的时候返回，不做操作
    if (indexPath.item == 0) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    HomeModel *model = self.array[indexPath.item-1];
    PushWebViewController *webVc = [[PushWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    webVc.isHome = YES;
    [self.navigationController pushViewController:webVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
@end
