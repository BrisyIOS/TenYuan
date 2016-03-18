//
//  WorthAroundController.m
//  WorthAround
//
//  Created by lanou on 15/11/14.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "WorthAroundController.h"
#import "WorthAroundHorModel.h"
#import "WorthAroundHorCell.h"
#import "Define.h"
#import "WorthAroundVerCell.h"
#import "WorthAroundVerModel.h"
#import "PresentWebViewController.h"


@interface WorthAroundController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSInteger _pages;
    NSInteger _bc;
}
@property (nonatomic, strong) NSMutableArray *horArray;
@property (nonatomic, strong) UICollectionView *horCollectionView;

@property (nonatomic, strong) NSMutableArray *verArray;
@property (nonatomic, strong) UICollectionView *verCollectionView;
@end

static NSString *cellIdentifier = @"cell";
static NSString *cellIdentifierVer = @"collectionCell";

@implementation WorthAroundController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 自定义上面的View
    [self createTitleView];
    
    // 初始化上面标题的数据
    [self createHorModel];
    
    // 创建上面横着的collectionView
    [self createHorCollectionView];
    
    // 创建竖屏的collectionView
    [self createVerCollectionView];
    
    // 一上来显示精选
    [self getTenWithBc:0 pages:1];
}
#pragma mark -- 创建上面的TitleView --
- (void)createTitleView
{
    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
    myView.backgroundColor = kMycolor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWith-100)/2, 20, 100, 44)];
    titleLabel.text = @"值得逛";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];//212 24 148
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [myView addSubview:titleLabel];
    [self.view addSubview:myView];
}

#pragma mark -- 初始化上面标题的数据 --
- (void)createHorModel
{
    NSArray *titleArray = @[@"精选",@"女装",@"男装",@"居家",@"母婴",@"鞋包",@"配饰",@"美食",@"数码",@"美妆",@"文体"];
    self.horArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        WorthAroundHorModel *model = [[WorthAroundHorModel alloc] init];
        model.title = titleArray[i];
        [self.horArray addObject:model];
    }
}
#pragma mark -- 创建横着的collectionView --
- (void)createHorCollectionView
{
    // 创建layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWith/5, 50);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.horCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith, 50) collectionViewLayout:layout];
    self.horCollectionView.dataSource = self;
    self.horCollectionView.delegate = self;
    self.horCollectionView.backgroundColor = [UIColor whiteColor];
    self.horCollectionView.bounces = NO;
    self.horCollectionView.showsHorizontalScrollIndicator = NO;
    // 注册
    [self.horCollectionView registerClass:[WorthAroundHorCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.horCollectionView];
    // 一上来就让新闻为选中状态，相当于把数组中的第0个model isSelect置成yes
    WorthAroundHorModel *model = self.horArray[0];
    model.isSelect = YES;
}
#pragma mark -- 创建竖屏的collectionView --
- (void)createVerCollectionView
{
    // 先把之前创建的collectionView移除
    if (self.verCollectionView) {
        [self.verCollectionView removeFromSuperview];
    }
    
    // 初始化数组和页码
    self.verArray = [NSMutableArray array];
    _pages = 1;
    
    // 先创建一个布局对象
    UICollectionViewFlowLayout *verLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = kScreenWith / 2;
    verLayout.itemSize = CGSizeMake(width, width+120);
    verLayout.minimumInteritemSpacing = 0;
    verLayout.minimumLineSpacing = 0;
    // 创建一个集合视图对象
    // UICollectionViewLayout是集合视图一部分的布局方式，控制集合视图整体的上下左右的边距以及视图的行和列边距
    self.verCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+50, kScreenWith, kScreenHeight-64-44-50) collectionViewLayout:verLayout];
    self.verCollectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.verCollectionView.dataSource = self;
    self.verCollectionView.delegate = self;
    // 注册cell
    [self.verCollectionView registerClass:[WorthAroundVerCell class] forCellWithReuseIdentifier:cellIdentifierVer];
    [self.view addSubview:self.verCollectionView];
    
    // 添加上拉加载更多和下拉刷新
    [self addRefresh];
}
#pragma mark -- 添加上拉加载和下拉刷新 --
- (void)addRefresh
{
    // 添加下拉刷新
    [self.verCollectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    
    // 添加上拉加载更多
    [self.verCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
}
#pragma mark -- 下拉刷新 --
- (void)headerAction
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 结束刷新
        [self.verCollectionView.header endRefreshing];
        return;
    }
    // 将数组中的数据全部删除
    if (_pages != 1) {
        // 删除下标是39之后的所有元素
        [self.verArray removeObjectsInRange:NSMakeRange(39, self.verArray.count-40)];
        // 刷新一下界面
        [self.verCollectionView reloadData];
    }
    // 结束刷新
    [self.verCollectionView.header endRefreshing];
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
        [self.verCollectionView.footer endRefreshing];
        return;
    }

    // 请求下一页的内容先让pages加1
    [self getTenWithBc:_bc pages:++_pages];
    // 结束刷新
    [self.verCollectionView.footer endRefreshing];
}
#pragma mark -- 数据请求解析 --
- (void)getTenWithBc:(NSInteger)bc pages:(NSInteger)pages
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=getworth&pages=%ld&bc=%ld&brandid=0&v=29", pages, bc];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            WorthAroundVerModel *model = [[WorthAroundVerModel alloc] init];
            [model setValuesForKeysWithDictionary:rowsDic];
            [self.verArray addObject:model];
        }
        // 回到主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.verCollectionView reloadData];
        });
        
    }];
    [dataTask resume];
}
#pragma mark -- 返回Item个数 --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.horCollectionView) {
        return self.horArray.count;
    } else {
        return self.verArray.count;
    }
    
}
#pragma mark -- 返回cell --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.horCollectionView) {
        WorthAroundHorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        WorthAroundHorModel *model = self.horArray[indexPath.item];
        if (cell == nil) {
            cell = [[WorthAroundHorCell alloc] init];
        }
        cell.label.text = model.title;
        // 判断一下是否点击过,YES显示红色、NO显示黑色
        if (model.isSelect) {
            cell.label.textColor = kMycolor;
            cell.view.hidden = NO;
        } else {
            cell.label.textColor = [UIColor blackColor];
            cell.view.hidden = YES;
        }
        return cell;
    } else {
        WorthAroundVerModel *model = self.verArray[indexPath.item];
        WorthAroundVerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierVer forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[WorthAroundVerCell alloc] init];
        }
        [cell setModel:model];
        return cell;
    }
    
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.horCollectionView) {
        // 让label的字体变红之前，把所有的字体颜色变回黑色
        for (WorthAroundHorCell *cell in collectionView.visibleCells) {
            cell.label.textColor = [UIColor blackColor];
            cell.view.hidden = YES;
        }
        // 把所有Model的isSelect变成NO
        for (WorthAroundHorModel *model in self.horArray) {
            model.isSelect = NO;
        }
        // 找到点击的cell
        WorthAroundHorCell *cell = (WorthAroundHorCell *)[collectionView cellForItemAtIndexPath:indexPath];
        // 让label的字体变红
        cell.label.textColor = kMycolor;
        cell.view.hidden = NO;
        // 找到对应的model，记录点击过了
        WorthAroundHorModel *model = self.horArray[indexPath.item];
        model.isSelect = YES;
        
        // 点击cell的时候自动改变collection的偏移量
        if (indexPath.item < 3) {
            [collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (indexPath.item > 2 && indexPath.item < 8) {
            [collectionView setContentOffset:CGPointMake((indexPath.item-2)*kScreenWith/5, 0) animated:YES];
        }
        else {
            [collectionView setContentOffset:CGPointMake(kScreenWith/5*6, 0) animated:YES];
        }

        // 判断点击的时哪个标题然后执行不同的数据请求
        [self judgeClickTitleToGetDataWithIndexPath:indexPath];
        
    } else {
        self.hidesBottomBarWhenPushed = YES;
        WorthAroundVerModel *model = self.verArray[indexPath.item];
        PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
        webVc.ProductUrl = model.ProductUrl;
        webVc.product = model.Name;
        [self presentViewController:webVc animated:YES completion:nil];
        self.hidesBottomBarWhenPushed = NO;;
    }
}
#pragma mark -- 判断点击的是哪个标题然后执行不同的数据请求 --
- (void)judgeClickTitleToGetDataWithIndexPath:(NSIndexPath *)indexPath
{
        switch (indexPath.item) {
            case 0:
            {
                // 创建一个新的collectionView
                [self createVerCollectionView];
                // 请求数据
                [self getTenWithBc:0 pages:1];
                _bc = 0;
                break;

            }
            case 1:
            {
                [self createVerCollectionView];
                [self getTenWithBc:1 pages:1];
                _bc = 1;
                break;
            }

            case 2:
            {
                [self createVerCollectionView];
                [self getTenWithBc:2 pages:1];
                _bc = 2;
                break;
            }

            case 3:
            {
                [self createVerCollectionView];
                [self getTenWithBc:3 pages:1];
                _bc = 3;
                break;
            }

            case 4:
            {
                [self createVerCollectionView];
                [self getTenWithBc:4 pages:1];
                _bc = 4;
                break;
            }

            case 5:
            {
                [self createVerCollectionView];
                [self getTenWithBc:5 pages:1];
                _bc = 5;
                break;
            }

            case 6:
            {
                [self createVerCollectionView];
                [self getTenWithBc:6 pages:1];
                _bc = 6;
                break;
            }

            case 7:
            {
                [self createVerCollectionView];
                [self getTenWithBc:7 pages:1];
                _bc = 7;
                break;
            }

            case 8:
            {
                [self createVerCollectionView];
                [self getTenWithBc:8 pages:1];
                _bc = 8;
                break;
            }

            case 9:
            {
                [self createVerCollectionView];
                [self getTenWithBc:9 pages:1];
                _bc = 9;
                break;
            }
                
            case 10:
            {
                [self createVerCollectionView];
                [self getTenWithBc:10 pages:1];
                _bc = 10;
                break;
            }
                
            default:
                break;
        }

    
}

@end
