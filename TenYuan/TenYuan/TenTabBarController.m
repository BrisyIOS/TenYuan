//
//  TenTabBarController.m
//  TenYuan
//
//  Created by lanou on 15/11/8.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "TenTabBarController.h"
#import "TenNavigationController.h"
#import "HomeController.h"
#import "BrandSaleController.h"
#import "TenController.h"
#import "WorthAroundController.h"
#import "Define.h"
//#import "PersonCenterController.h"

@interface TenTabBarController ()

@end

@implementation TenTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];

    // 创建首页
    TenNavigationController *homeNav = [[TenNavigationController alloc] initWithRootViewController:[[HomeController alloc] init]];
    homeNav.tabBarItem = [self setTabBarItemWithTitle:@"首页" Image:@"home" selectImage:@"home_1"];

    
    // 创建品牌特卖
    BrandSaleController *brandSaleVc = [[BrandSaleController alloc] init];
    brandSaleVc.tabBarItem = [self setTabBarItemWithTitle:@"品牌特卖" Image:@"BrandSale" selectImage:@"BrandSale_1"];

    
    // 创建十元
    TenController *tenVc = [[TenController alloc] init];
    tenVc.tabBarItem = [self setTabBarItemWithTitle:@"十元购" Image:@"ten" selectImage:@"ten_1"];
    
    
    // 创建值得逛
    WorthAroundController *worthAroundVc = [[WorthAroundController alloc] init];
    worthAroundVc.tabBarItem = [self setTabBarItemWithTitle:@"值得逛" Image:@"WorthAround" selectImage:@"WorthAround_1"];

    
    // 创建个人中心
//    PersonCenterController *personCenterVc = [[PersonCenterController alloc] init];
//    personCenterVc.tabBarItem = [self setTabBarItemWithTitle:@"个人中心" Image:@"PersonalCenter" selectImage:@"PersonalCenter_1"];
    
    
    // 设置tabBarItem的字体颜色
    // 不选中的时候的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // 选中的时候的字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIColor magentaColor],NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];
    self.tabBar.barTintColor = kMycolor;
    
    self.viewControllers = @[homeNav, brandSaleVc, tenVc, worthAroundVc];
}
#pragma mark -- 给tabBarItem赋值nomal和select图片 --
- (UITabBarItem *)setTabBarItemWithTitle:(NSString *)title Image:(NSString *)image selectImage:(NSString *)selectImage
{
    // 不选中显示的图片
    UIImage *imag = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 选中的时候显示的图片
    UIImage *imageSel = [[UIImage imageNamed:selectImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:imag selectedImage:imageSel];
    return tabBarItem;
}

@end
