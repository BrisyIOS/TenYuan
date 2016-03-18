//
//  HomeUpCell.m
//  TenYuan
//
//  Created by lanou on 15/11/30.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "HomeUpCell.h"
#import "Define.h"

@interface HomeUpCell ()<UIScrollViewDelegate>{
    NSInteger _num;
}
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *page;
@end

@implementation HomeUpCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 创建scrollView
        [self createScrollView];
        
        // 创建中间的Button
        [self createMidView];
        
        // 创建下面的View
        [self createDownView];
        
    }
    return self;
}
#pragma mark -- 创建scrollView --
- (void)createScrollView
{
    _num = 1;
    CGFloat height = kScreenWith*1.24;
    CGFloat upHeight = height*0.3;
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, upHeight)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(kScreenWith * 6, upHeight);
    // 用户看到的 只有9张图片 实际上 有11张图片 我们一上来 让用户第一眼看到的实际上是第二张图片 所以需要改变偏移量
    self.scrollView.contentOffset = CGPointMake(kScreenWith * 1, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    [self.contentView addSubview:self.scrollView];
    
    // 制作一个假象 实际上的第一张图片 和 最后一张图片 是一样的 当我们滑动到 最后一张图片的时候 让scrollView的偏移量 回到第一张 才能够实现 循环滚动的效果
    
    UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWith, upHeight)];
    firstImageView.image = [UIImage imageNamed:@"14"];
    firstImageView.userInteractionEnabled = YES;
    firstImageView.tag = 304;
    UITapGestureRecognizer *upFirstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap:)];
    [firstImageView addGestureRecognizer:upFirstTap];
    [self.scrollView addSubview:firstImageView];
    
    UIImageView *secondImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith * 5, 0, kScreenWith, upHeight)];
    secondImageView.userInteractionEnabled = YES;
    secondImageView.tag = 305;
    UITapGestureRecognizer *upSecondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap:)];
    [secondImageView addGestureRecognizer:upSecondTap];
    secondImageView.image = [UIImage imageNamed:@"11"];
    [self.scrollView addSubview:secondImageView];
    
    for (int i = 0; i < 4; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWith * (i + 1), 0, kScreenWith, upHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 300+i;
        UITapGestureRecognizer *upTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upTap:)];
        [imageView addGestureRecognizer:upTap];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1%d", i + 1]];
        [self.scrollView addSubview:imageView];
    }
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake((kScreenWith-100)/2, upHeight-30, 100, 30)];
    self.page.numberOfPages = 4;
    self.page.currentPageIndicatorTintColor = [UIColor redColor];
    self.page.pageIndicatorTintColor = [UIColor whiteColor];
    [self.contentView addSubview:self.page];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(playAction) userInfo:nil repeats:YES];
    [self.timer fire];
    
}
#pragma mark -- upTap手势 --
- (void)upTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    switch (imgView.tag) {
        case 300:
            [self.upTapDelegate upTapDelegateWithActid:25 catName:@"11" tName:@"甜美韩妆走起"];
            break;
        case 301:
            [self.upTapDelegate upTapDelegateWithActid:24 catName:@"12" tName:@"拒做“女旱子”"];
            break;
        case 302:
            [self.upTapDelegate upTapDelegateWithActid:23 catName:@"13" tName:@"一件外套搞定温差"];
            break;
        case 303:
            [self.upTapDelegate upTapDelegateWithActid:22 catName:@"14" tName:@"鞋包特辑"];
            break;
        case 304:
            [self.upTapDelegate upTapDelegateWithActid:22 catName:@"14" tName:@"鞋包特辑"];
            break;
        case 305:
            [self.upTapDelegate upTapDelegateWithActid:25 catName:@"11" tName:@"甜美韩妆走起"];
            break;
        default:
            break;
    }
}
#pragma mark -- 定时器方法 --
- (void)playAction
{
    self.page.currentPage = _num-1;
    [self.scrollView setContentOffset:CGPointMake(kScreenWith*(_num++), 0) animated:YES];
    if (_num == 5) {
        _num = 1;
    }
}
#pragma mark -- 改变UIPageControl --
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    UIPageControl *page = self.contentView.subviews[1];
    
    // 判断是第几张图
    NSInteger index = scrollView.contentOffset.x / kScreenWith;
    if (index == 0)
    {
        [scrollView setContentOffset:CGPointMake(kScreenWith * 4, 0) animated:NO];
        page.currentPage = 9;
    }
    else if (index == 5)     {
        [scrollView setContentOffset:CGPointMake(kScreenWith * 1, 0) animated:NO];
        page.currentPage = 0;
    } else {
        page.currentPage = index - 1;
    }
    
}
#pragma mark -- 创建midView --
- (void)createMidView
{
    CGFloat height = kScreenWith*1.24;
    CGFloat upHeight = height*0.3;
    CGFloat width = (kScreenWith-160)/4;
    
    // 女装
    UIView *oneView = [self createbgViewWithFrame:CGRectMake(20, upHeight+10, width, width) color:kMycolor];
    UIImageView *oneImgView = [self createImageWithFrame:CGRectMake(10, 10, width-20, width-20) color:kMycolor imageName:@"icon-nvzhuang" tag:106];
    UILabel *oneLabel = [self createLabelWithFrame:CGRectMake(20, upHeight+width+10, width, 30) name:@"女装"];
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [oneImgView addGestureRecognizer:oneTap];
    [oneView addSubview:oneImgView];
    [self.contentView addSubview:oneLabel];
    [self.contentView addSubview:oneView];
    
    // 居家
    UIView *twoView = [self createbgViewWithFrame:CGRectMake(60+width, upHeight+10, width, width) color:[UIColor orangeColor]];
    UIImageView *twoImgView = [self createImageWithFrame:CGRectMake(10, 10, width-20, width-20) color:[UIColor orangeColor] imageName:@"icon-jujia" tag:107];
    UILabel *twoLabel = [self createLabelWithFrame:CGRectMake(60+width, upHeight+width+10, width, 30) name:@"居家"];
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [twoImgView addGestureRecognizer:twoTap];
    [twoView addSubview:twoImgView];
    [self.contentView addSubview:twoLabel];
    [self.contentView addSubview:twoView];
    
    // 鞋包
    UIView *threeView = [self createbgViewWithFrame:CGRectMake(100+width*2, upHeight+10, width, width) color:[UIColor blueColor]];
    UIImageView *threeImgView = [self createImageWithFrame:CGRectMake(10, 10, width-20, width-20) color:[UIColor blueColor] imageName:@"icon-xiebao" tag:108];
    UILabel *threeLabel = [self createLabelWithFrame:CGRectMake(100+width*2, upHeight+width+10, width, 30) name:@"鞋包"];
    UITapGestureRecognizer *threeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [threeImgView addGestureRecognizer:threeTap];
    [threeView addSubview:threeImgView];
    [self.contentView addSubview:threeLabel];
    [self.contentView addSubview:threeView];
    
    // 全部
    UIView *fourView = [self createbgViewWithFrame:CGRectMake(140+width*3, upHeight+10, width, width) color:[UIColor redColor]];
    UIImageView *fourImgView = [self createImageWithFrame:CGRectMake(10, 10, width-20, width-20) color:[UIColor redColor] imageName:@"icon-quanbu" tag:109];
    UILabel *fourLabel = [self createLabelWithFrame:CGRectMake(140+width*3, upHeight+width+10, width, 30) name:@"更多"];
    UITapGestureRecognizer *fourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [fourImgView addGestureRecognizer:fourTap];
    [fourView addSubview:fourImgView];
    [self.contentView addSubview:fourLabel];
    [self.contentView addSubview:fourView];
}
#pragma mark -- 创建midSubView --
- (UIView *)createbgViewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    view.layer.cornerRadius = frame.size.width/2;
    return view;
}
#pragma mark -- 创建midSubimageView --
- (UIImageView *)createImageWithFrame:(CGRect)frame color:(UIColor *)color imageName:(NSString *)imgeName tag:(NSInteger)tag
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.backgroundColor = color;
    imgView.image = [UIImage imageNamed:imgeName];
    imgView.tag = tag;
    imgView.userInteractionEnabled = YES;
    return imgView;
}
#pragma mark -- 创建midSublabel --
- (UILabel *)createLabelWithFrame:(CGRect)frame name:(NSString *)name
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = name;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
#pragma mark -- 创建downView --
- (void)createDownView
{
    CGFloat height = kScreenWith*1.24;
    CGFloat downHeight = height/2;
    
    // 灰色的线
    UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, downHeight, kScreenWith, 5)];
    spaceView.backgroundColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.5];
    [self.contentView addSubview:spaceView];
    
    // 今日更新
    UIImageView *oneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height/2+5, kScreenWith*0.4, downHeight-5)];
    oneImageView.tag = 101;
    // 创建轻拍手势
    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    oneImageView.userInteractionEnabled = YES;
    [oneImageView addGestureRecognizer:oneTap];
    oneImageView.image = [UIImage imageNamed:@"jinrigengxin"];
    oneImageView.layer.borderWidth = 0.5;
    oneImageView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
    [self.contentView addSubview:oneImageView];
    
    // 手机
    UIImageView *twoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWith*0.4, height/2+5, kScreenWith*0.3, (downHeight-5)/2)];
    twoImageView.tag = 102;
    // 创建轻拍手势
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    twoImageView.userInteractionEnabled = YES;
    [twoImageView addGestureRecognizer:twoTap];
    twoImageView.image = [UIImage imageNamed:@"shoujizhoubian"];
    twoImageView.layer.borderWidth = 0.3;
    twoImageView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
    [self.contentView addSubview:twoImageView];
    
    // 美食
    UIImageView *threeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWith*0.4, height/2+5+(downHeight-5)/2, kScreenWith*0.3, (downHeight-5)/2)];
    threeImageView.tag = 103;
    // 创建轻拍手势
    UITapGestureRecognizer *threeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    threeImageView.userInteractionEnabled = YES;
    [threeImageView addGestureRecognizer:threeTap];
    threeImageView.image = [UIImage imageNamed:@"meishihui"];
    threeImageView.layer.borderWidth = 0.3;
    threeImageView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
    [self.contentView addSubview:threeImageView];
    
    //美妆
    UIImageView *fourImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWith*0.7, height/2+5, kScreenWith*0.3, (downHeight-5)/2)];
    fourImageView.tag = 104;
    // 创建轻拍手势
    UITapGestureRecognizer *fourTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    fourImageView.userInteractionEnabled = YES;
    [fourImageView addGestureRecognizer:fourTap];
    fourImageView.image = [UIImage imageNamed:@"meizhuanggehu"];
    fourImageView.layer.borderWidth = 0.3;
    fourImageView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
    [self.contentView addSubview:fourImageView];
    
    // 最后疯抢
    UIImageView *fiveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWith*0.7, height/2+5+(downHeight-5)/2, kScreenWith*0.3, (downHeight-5)/2)];
    fiveImageView.tag = 105;
    // 创建轻拍手势
    UITapGestureRecognizer *fiveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    fiveImageView.userInteractionEnabled = YES;
    [fiveImageView addGestureRecognizer:fiveTap];
    fiveImageView.image = [UIImage imageNamed:@"zuihoufengqiang"];
    fiveImageView.layer.borderWidth = 0.3;
    fiveImageView.layer.borderColor = [UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:0.4].CGColor;
    [self.contentView addSubview:fiveImageView];

}
#pragma mark -- Tap手势 --
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imgView = (UIImageView *)tap.view;
    switch (imgView.tag) {
        case 101:// 今日更新
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:0 sc:0 channel:0 daynews:@"1" actid:0 detaiName:@"今日更新"];
            break;
        case 102:// 手机周边
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:0 sc:0 channel:0 daynews:@"1" actid:2 detaiName:@"手机周边"];
            break;
        case 103:// 美食
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:7 sc:0 channel:0 daynews:@"" actid:0 detaiName:@"美食"];
            break;
        case 104:// 美妆
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:9 sc:0 channel:0 daynews:@"" actid:0 detaiName:@"美妆个护"];
            break;
        case 105:// 最后疯抢
            [self.downLastSaleDelegate downLastSale];
            break;
        case 106:// 女装
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:1 sc:0 channel:0 daynews:@"" actid:0 detaiName:@"女装"];
            break;
        case 107:// 居家
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:3 sc:0 channel:0 daynews:@"" actid:0 detaiName:@"居家"];
            break;
        case 108:// 鞋包
            [self.downTapDelegate downTapDelegatePassToSearchVcWithBc:5 sc:0 channel:0 daynews:@"" actid:0 detaiName:@"鞋包"];
            break;
        case 109:// 更多
            [self.midMoreDelegate midMoreDelegate];
            break;
    }
    
}

@end
