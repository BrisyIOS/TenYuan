//
//  BrandSaleDetailController.m
//  WorthAround
//
//  Created by lanou on 15/11/17.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "BrandSaleDetailController.h"
#import "Define.h"
#import "BrandSaleDetailModel.h"
#import "BrandSaleDetailCell.h"
#import "PresentWebViewController.h"
#import "UIButton+WebCache.h"

@interface BrandSaleDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *verArray;
@property (nonatomic, strong) UICollectionView *verCollectionView;

@property (nonatomic, strong) UIButton *imgUrlSmlBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *disCountLabel;

@end

static NSString *cellIdentifierVer = @"collectionCell";
@implementation BrandSaleDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建上面的标题View和品牌的log名字和折扣
    [self createTitleViewAndLogAndNameAndDiscount];
    
    // 先创建一个布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = kScreenWith / 2;
    layout.itemSize = CGSizeMake(width, width+120);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    // 创建一个集合视图对象
    // UICollectionViewLayout是集合视图一部分的布局方式，控制集合视图整体的上下左右的边距以及视图的行和列边距
    self.verCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith, kScreenHeight-64) collectionViewLayout:layout];
    self.verCollectionView.backgroundColor = [UIColor whiteColor];
    // 设置代理
    self.verCollectionView.dataSource = self;
    self.verCollectionView.delegate = self;
    // 注册cell
    [self.verCollectionView registerClass:[BrandSaleDetailCell class] forCellWithReuseIdentifier:cellIdentifierVer];
    [self.view addSubview:self.verCollectionView];
    // 数据请求
    [self getTenWithBc:[self.model.brandId integerValue]];

}
#pragma mark -- 返回上一页面 --
- (void)backAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 创建上面的标题View和品牌的log名字和折扣 --
- (void)createTitleViewAndLogAndNameAndDiscount
{
    // 创建View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, 64)];
    //titleView.backgroundColor = kMycolor;
    
    // 创建logLabel
    self.imgUrlSmlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgUrlSmlBtn.frame = CGRectMake(10, 25, 50, 30);
    [self.imgUrlSmlBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgUrlSmlBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img2.syby8.com%@", self.model.ImgUrlSml]] forState:UIControlStateNormal];
    [titleView addSubview:self.imgUrlSmlBtn];
    
    // 创建nameLabel
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imgUrlSmlBtn.width+20, 25, 100, 30)];
    self.nameLabel.text = self.model.Name;
    [titleView addSubview:self.nameLabel];
    
    // 创建discountLabel
    self.disCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+self.imgUrlSmlBtn.width+self.nameLabel.width, 25, kScreenWith-100-50-20-20, 30)];
    self.disCountLabel.textColor = kMycolor;
    NSString *string = [NSString stringWithFormat:@"%.1f折起", [self.model.DisCount floatValue]];
    if ([string hasSuffix:@".0折起"]) {
        self.disCountLabel.text = [string stringByReplacingOccurrencesOfString:@".0折起" withString:@"折起"];
    }
    else {
        self.disCountLabel.text = string;
    }
    self.disCountLabel.textAlignment = NSTextAlignmentRight;
    [titleView addSubview:self.disCountLabel];
    
    [self.view addSubview:titleView];
    
}
#pragma mark -- 数据请求解析 --
- (void)getTenWithBc:(NSInteger)brandid
{
    if (![[NetworkState shareInstance] reachability]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    // post请求
    NSString *url = @"http://www.syby8.com/apptools/productlist.aspx";
    NSString *postString = [NSString stringWithFormat:@"act=getworth&pages=1&bc=0&brandid=%ld&v=29",brandid];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        self.verArray = [NSMutableArray array];
        for (NSDictionary *rowsDic in dic[@"rows"]) {
            BrandSaleDetailModel *model = [[BrandSaleDetailModel alloc] init];
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
#pragma mark -- 返回行 --
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.verArray.count;
}
#pragma mark -- 返回Item --
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSaleDetailModel *model = self.verArray[indexPath.item];
    BrandSaleDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifierVer forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}
#pragma mark -- 点击Item --
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BrandSaleDetailModel *model = self.verArray[indexPath.row];
    PresentWebViewController *webVc = [[PresentWebViewController alloc] init];
    webVc.ProductUrl = model.ProductUrl;
    webVc.product = model.Name;
    [self presentViewController:webVc animated:NO completion:nil];
}

@end
