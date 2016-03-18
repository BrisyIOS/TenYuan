//
//  BrandSaleController.m
//  TenYuan
//
//  Created by lanou on 15/11/8.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "BrandSaleController.h"
#import "BrandSaleHorCell.h"
#import "BrandSaleHorModel.h"
#import "BrandSaleVerCell.h"
#import "BrandSaleVerModel.h"
#import "BrandSaleDetailController.h"
#import "Define.h"

@interface BrandSaleController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _pages;
    NSInteger _bc;
    NSInteger _total;
    BOOL _isEqual;
}
@property (nonatomic, strong) NSMutableArray *horArray;
@property (nonatomic, strong) UICollectionView *horCollectionView;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;

@end

static NSString *cellIdentifier = @"cell";

@implementation BrandSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isHome) {
        
        // 从Home跳转过来的设置
        [self createBackHomeAndTitle];
        
        // 一上来就请求一次数据
        [self getBrandSaleWithBclass:97 pages:1];
    } else {
        // 初始化上面标题的数据
        [self createHorModel];
        
        // 一上来就请求一次数据
        [self getBrandSaleWithBclass:99 pages:1];
    }
    
    // 创建collectionView
    [self createCollectionView];
    
    // 创建tableView
    [self createTableView];
}
#pragma mark -- 从Home跳转过来的设置 --
- (void)createBackHomeAndTitle
{
    // 返回的按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // 标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    label.text = @"最后疯抢";
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
}
#pragma mark -- 返回 --
- (void)back:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark -- 初始化上面标题的数据 --
- (void)createHorModel
{
    NSArray *titleArray = @[@"最新上线",@"昨日上线",@"最后疯抢",@"精致女装",@"鞋包配饰",@"居家生活",@"美妆个护",@"美食每刻",@"母婴用品",@"数码家电",@"精品男装",@"文体用品"];
    self.horArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        
        BrandSaleHorModel *model = [[BrandSaleHorModel alloc] init];
        model.title = titleArray[i];
        [self.horArray addObject:model];
    }
}
#pragma mark -- 创建collectionView --
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWith/4, 50);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.horCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, kScreenWith, 50) collectionViewLayout:layout];
    self.horCollectionView.dataSource = self;
    self.horCollectionView.delegate = self;
    self.horCollectionView.backgroundColor = [UIColor whiteColor];
    self.horCollectionView.bounces = NO;
    self.horCollectionView.showsHorizontalScrollIndicator = NO;
    [self.horCollectionView registerClass:[BrandSaleHorCell class] forCellWithReuseIdentifier:cellIdentifier];
    [self.view addSubview:self.horCollectionView];
    // 一上来就让新闻为选中状态，相当于把数组中的第0个model isSelect置成yes
    BrandSaleHorModel *model = self.horArray[0];
    model.isSelect = YES;
}
#pragma mark -- 创建tableView --

- (void)createTableView
{
    // 先把之前创建的tableView移除
    if (self.tableView) {
        [self.tableView removeFromSuperview];
    }
    // 初始化数组
    self.array = [NSMutableArray array];
    _pages = 1;
    
    // 初始化tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, kScreenWith, kScreenHeight-70-44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = kScreenWith*0.88;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    // 添加上拉加载更多和下拉刷新
    [self addRefresh];
    
}
#pragma mark -- 添加上拉加载和下拉刷新 --
- (void)addRefresh
{
    // 添加下拉刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(headerAction)];
    
    // 添加上拉加载更多
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerAction)];
}
#pragma mark -- 下拉刷新 --
- (void)headerAction
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 结束刷新
        [self.tableView.header endRefreshing];
        return;
    }
    //NSLog(@"total == %ld", _total);
    if (_total < 20) {
        // 结束刷新
        [self.tableView.header endRefreshing];
        // 将pages置成1
        _pages = 1;
        return;
    }
    // 将数组中的数据全部删除
    if (_pages != 1) {
        // 删除下标是19之后的所有元素
        [self.array removeObjectsInRange:NSMakeRange(19, self.array.count-20)];
        // 刷新一下界面
        [self.tableView reloadData];
    }
    // 结束刷新
    [self.tableView.header endRefreshing];
    // 将pages置成1
    _pages = 1;
}
#pragma mark -- 上拉加载 --
- (void)footerAction
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        // 结束刷新
        [self.tableView.footer endRefreshing];
        return;
    }
    if (!_isEqual) {
        // 请求下一页的内容先让pages加1
        [self getBrandSaleWithBclass:_bc pages:++_pages];
    } else {
        _pages = 1;
    }
    // 结束刷新
    [self.tableView.footer endRefreshing];
}
#pragma mark -- 数据请求解析 --
- (void)getBrandSaleWithBclass:(NSInteger)bclass pages:(NSInteger)pages
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    NSString *url = @"http://www.syby8.com/apptools/brandsale.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=brandlist&cpage=%ld&pagesize=20&bclass=%ld&v=28", pages, bclass];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            BrandSaleVerModel *model = [[BrandSaleVerModel alloc] init];
            [model setValuesForKeysWithDictionary:rowsDic];
            
            // 将model.ProductInfo转成NSData
            NSString *modelString = model.ProductInfo;
            NSData *modelData = [modelString dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableArray *modelArray = [NSJSONSerialization JSONObjectWithData:modelData options:NSJSONReadingMutableContainers error:nil];
            
            model.array = [NSMutableArray array];
            for (NSDictionary *modelDic in modelArray) {
                BrandSaleVerModel *bmodel = [[BrandSaleVerModel alloc] init];
                bmodel.anotherModel = [[anotherModel alloc] init];
                [bmodel.anotherModel setValuesForKeysWithDictionary:modelDic];
                
                [model.array addObject:bmodel.anotherModel];
            }
            [self.array addObject:model];
        }
        NSNumber *number = dic[@"total"];
        _isEqual = (self.array.count == [number integerValue]);
        _total = [number integerValue];
        
        // 回到主线程刷新UI界面
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [dataTask resume];
}

#pragma mark -------------collectionView------------------------------------------------------

#pragma mark -- 返回cell的个数 --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.horArray.count;
}
#pragma mark -- 返回cell --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSaleHorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    BrandSaleHorModel *model = self.horArray[indexPath.item];
    if (cell == nil) {
        cell = [[BrandSaleHorCell alloc] init];
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
}
#pragma mark -- 点击cell --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 让label的字体变红之前，把所有的字体颜色变回黑色
    for (BrandSaleHorCell *cell in collectionView.visibleCells) {
        cell.label.textColor = [UIColor blackColor];
        cell.view.hidden = YES;
    }
    // 把所有Model的isSelect变成NO
    for (BrandSaleHorModel *model in self.horArray) {
        model.isSelect = NO;
    }
    // 找到点击的cell
    BrandSaleHorCell *cell = (BrandSaleHorCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 让label的字体变红
    cell.label.textColor = kMycolor;
    cell.view.hidden = NO;
    // 找到对应的model，记录点击过了
    BrandSaleHorModel *model = self.horArray[indexPath.item];
    model.isSelect = YES;
    
    // 点击cell的时候自动改变collection的偏移量
    if (indexPath.item < 2) {
        [collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (indexPath.item > 1 && indexPath.item < 10) {
        [collectionView setContentOffset:CGPointMake((indexPath.item-1)*kScreenWith/4, 0) animated:YES];
    }
    else {
        [collectionView setContentOffset:CGPointMake(kScreenWith*2, 0) animated:YES];
    }
    switch (indexPath.row) {
        case 0:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:99 pages:1];
            _bc = 99;
            break;
        }
            
        case 1:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:98 pages:1];
            _bc = 98;
            break;
        }
            
        case 2:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:97 pages:1];
            _bc = 97;
            break;
        }
            
        case 3:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:1 pages:1];
            _bc = 1;
            break;
        }
            
        case 4:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:5 pages:1];
            _bc = 5;
            break;
        }
            
        case 5:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:3 pages:1];
            _bc = 3;
            break;
        }
            
        case 6:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:9 pages:1];
            _bc = 9;
            break;
        }
            
        case 7:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:7 pages:1];
            _bc = 7;
            break;
        }
            
        case 8:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:4 pages:1];
            _bc = 4;//15
            break;
        }
            
        case 9:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:8 pages:1];
            _bc = 8;//10
            break;
        }
            
        case 10:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:2 pages:1];
            _bc = 2;
            break;
        }
            
        case 11:
        {
            [self createTableView];
            [self getBrandSaleWithBclass:10 pages:1];
            _bc = 10;
            break;
        }
            
        default:
            break;
    }

}

#pragma mark -------------tableView-----------------------------------------------------------

#pragma mark -- 返回cell的个数 --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}
#pragma mark -- 返回cell --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSaleVerModel *model = self.array[indexPath.row];
    BrandSaleVerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"verCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BrandSaleVerCell" owner:nil options:nil] firstObject];
    }
    [cell setBModel:model];
    return cell;
}
#pragma mark -- 点击cell --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSaleVerModel *model = self.array[indexPath.row];
    BrandSaleDetailController *brandSaleDetailVc = [[BrandSaleDetailController alloc] init];
    brandSaleDetailVc.model = model;
    [self presentViewController:brandSaleDetailVc animated:NO completion:nil];
}

@end
