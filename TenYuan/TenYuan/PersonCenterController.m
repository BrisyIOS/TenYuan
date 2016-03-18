//
//  PersonCenterController.m
//  TenYuan
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "PersonCenterController.h"
#import "Define.h"

@interface PersonCenterController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tbArray;
@property (nonatomic, strong) NSArray *creditArray;

@end

@implementation PersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tbArray = @[@"去淘宝查看订单",@"去淘宝查看物流信息",@"去淘宝查看我的购物车",@"去淘宝查看我的收藏夹"];
    self.creditArray = @[@"签到领积分",@"我的积分",@"积分商城"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith, kScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
}
// 返回分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
// 返回cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}
// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.tbArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
        
    } else {
        cell.textLabel.text = self.creditArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%ld", indexPath.row]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}




@end
