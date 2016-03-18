//
//  TenCell.m
//  TenYuan
//
//  Created by lanou on 15/11/14.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "TenCell.h"
#import "Define.h"

@interface TenCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *ProductImgWX;
@property (nonatomic, strong) UILabel *Name;
@property (nonatomic, strong) UILabel *NewPrice;
@property (nonatomic, strong) UILabel *OldPrice;
@property (nonatomic, strong) UILabel *Discount;
@property (nonatomic, strong) UILabel *SaleTotal;
@property (nonatomic, strong) UILabel *IsBaoYou;

@end

@implementation TenCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // lineView
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWith/2, 0.3)];
        self.lineView.backgroundColor = [UIColor grayColor];
        self.lineView.alpha = 0.3;
        [self.contentView addSubview:self.lineView];
        // 图片
        CGFloat width = (kScreenWith - 20) / 2;
        CGFloat height = width * 880 / 800;
        self.ProductImgWX = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width, height)];
        self.ProductImgWX.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.ProductImgWX];

        // 创建标题
        self.Name = [[UILabel alloc] initWithFrame:CGRectMake(5, self.ProductImgWX.height, width-5, 40)];
        self.Name.textColor = [UIColor blackColor];
        self.Name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.Name];
        // 创建现在价格
        self.NewPrice = [[UILabel alloc] initWithFrame:CGRectMake(5, self.ProductImgWX.height+self.Name.height, 45, 30)];
        self.NewPrice.textColor = [UIColor redColor];
        [self.contentView addSubview:self.NewPrice];
        // 创建原价
        self.OldPrice = [[UILabel alloc] initWithFrame:CGRectMake(50, self.ProductImgWX.height+self.Name.height, 70, 30)];
        self.OldPrice.textColor = [UIColor grayColor];
        self.OldPrice.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.OldPrice];
        // 创建折扣
        self.Discount = [[UILabel alloc] initWithFrame:CGRectMake(width-60, self.ProductImgWX.height+self.Name.height, 60, 30)];
        self.Discount.textColor = [UIColor grayColor];
        self.Discount.font = [UIFont systemFontOfSize:14];
        self.Discount.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.Discount];
        // 创建已售出
        self.SaleTotal = [[UILabel alloc] initWithFrame:CGRectMake(5, self.ProductImgWX.height+self.Name.height+self.NewPrice.height, 135, 30)];
        self.SaleTotal.textColor = [UIColor grayColor];
        self.SaleTotal.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.SaleTotal];
        // 创建是否包邮
        self.IsBaoYou = [[UILabel alloc] initWithFrame:CGRectMake(width-50, self.ProductImgWX.height+self.Name.height+self.NewPrice.height, 50, 30)];
        self.IsBaoYou.textColor = [UIColor grayColor];
        self.IsBaoYou.font = [UIFont systemFontOfSize:14];
        self.IsBaoYou.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.IsBaoYou];
    }
    return self;
}
- (void)setModel:(TenModel *)model
{
    _model = model;
    // 给图片赋值
    [self.ProductImgWX sd_setImageWithURL:[NSURL URLWithString:model.ProductImgWX]];
    // 给标题赋值
    self.Name.text = model.Name;
    // 给现在的价格赋值
    NSString *newString = [NSString stringWithFormat:@"%@", [model.NewPrice stringValue]];
    if ([newString rangeOfString:@"."].location != NSNotFound) {
        // 字符串中包含"."
        newString = [NSString stringWithFormat:@"¥%.1f", [model.NewPrice floatValue]];
        self.NewPrice.text = newString;
    } else {
        // 不包含"."
        self.NewPrice.text = [NSString stringWithFormat:@"¥%@", newString];
    }
    // 给原来的价格赋值
    NSString *oldString = [NSString stringWithFormat:@"%@", [model.OldPrice stringValue]];
    if ([oldString rangeOfString:@"."].location != NSNotFound) {
        oldString = [NSString stringWithFormat:@"%.1f", [model.OldPrice floatValue]];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldString attributes:attribtDic];
        self.OldPrice.attributedText = attribtStr;
    } else {
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldString attributes:attribtDic];
        self.OldPrice.attributedText = attribtStr;
    }
    // 给折扣赋值
    NSString *string = [NSString stringWithFormat:@"%.1f折", [model.Discount floatValue]];
    if ([string hasSuffix:@".0折"]) {
        self.Discount.text = [string stringByReplacingOccurrencesOfString:@".0折" withString:@"折"];
    }
    else {
        self.Discount.text = string;
    }
    // 给是否包邮赋值
    self.SaleTotal.text = [NSString stringWithFormat:@"已售%ld件", model.SaleTotal];
    if (model.SaleTotal) {
        self.IsBaoYou.text = @"包邮";
    } else {
        self.IsBaoYou.text = @"不包邮";
    }
}

@end
