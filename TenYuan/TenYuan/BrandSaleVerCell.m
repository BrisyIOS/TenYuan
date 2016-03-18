//
//  BrandSaleVerCell.m
//  WorthAround
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "BrandSaleVerCell.h"
#import "Define.h"

@interface BrandSaleVerCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ImgUrlSml;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *redDiscount;
@property (weak, nonatomic) IBOutlet UILabel *endDate;

@property (weak, nonatomic) IBOutlet UIImageView *leftImg;
@property (weak, nonatomic) IBOutlet UILabel *leftPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDiscountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *upImg;
@property (weak, nonatomic) IBOutlet UILabel *upPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *upDiscountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *downImg;
@property (weak, nonatomic) IBOutlet UILabel *downPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *downDiscountLabel;

@end

@implementation BrandSaleVerCell

#pragma mark -- 重写BrandSaleVerModel的set方法 --
- (void)setBModel:(BrandSaleVerModel *)bModel
{
    _bModel = bModel;
    
    // 得到现在的时间和活动时间的差值
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *endDate = [formatter dateFromString:bModel.EndDateStr];
    NSTimeInterval timeInterval = [endDate timeIntervalSinceNow];

    // 给剩余天数赋值
    if ((int)timeInterval / 3600 >= 24) {
       self.endDate.text = [NSString stringWithFormat:@"剩%d天", (int)timeInterval / 86400];
    } else {
        self.endDate.text = [NSString stringWithFormat:@"剩%d小时", (int)timeInterval / 3600];
    }
    
    // 给三张大图添加图片
    anotherModel *leftModel = bModel.array[0];
    anotherModel *upModel = bModel.array[1];
    anotherModel *downModel = bModel.array[2];
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.syby8.com/%@", leftModel.ProductImg]]];
    [self.upImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.syby8.com/%@", upModel.ProductImg]]];
    [self.downImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.syby8.com/%@", downModel.ProductImg]]];
    
    // 给品牌的log添加图片
    [self.ImgUrlSml sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.syby8.com%@", bModel.ImgUrlSml]]];
    // 品牌的名字
    self.brandName.text = bModel.Name;
    // 折扣
    self.redDiscount.backgroundColor = kMycolor;
    self.redDiscount.layer.cornerRadius = 15;
    self.redDiscount.layer.masksToBounds = YES;
    self.redDiscount.text = [NSString stringWithFormat:@"2.1折起"];
    NSString *redDiscountString = [NSString stringWithFormat:@"%.1f折起", [bModel.DisCount floatValue]];
    if ([redDiscountString hasSuffix:@".0折起"]) {
        self.redDiscount.text = [redDiscountString stringByReplacingOccurrencesOfString:@".0折起" withString:@"折起"];
    } else {
        self.redDiscount.text = redDiscountString;
    }
    
    // 给左边的label赋值价格和折扣
    NSString *leftPriceString = [NSString stringWithFormat:@"%@", [leftModel.NewPrice stringValue]];
    NSString *leftDiscountring = [NSString stringWithFormat:@"%.1f折", [leftModel.disCount floatValue]];
    [self setPrice:leftPriceString discount:leftDiscountring anotherModel:leftModel priceLabel:self.leftPriceLabel discountLabel:self.leftDiscountLabel];
    
    // 给右边上边的label赋值价格和折扣
    NSString *upPriceString = [NSString stringWithFormat:@"%@", [upModel.NewPrice stringValue]];
    NSString *upDiscountString = [NSString stringWithFormat:@"%.1f折", [upModel.disCount floatValue]];
    [self setPrice:upPriceString discount:upDiscountString anotherModel:upModel priceLabel:self.upPriceLabel discountLabel:self.upDiscountLabel];
    
    // 给右边的下边的label赋值价格和折扣
    NSString *downPriceString = [NSString stringWithFormat:@"%@", [downModel.NewPrice stringValue]];
    NSString *downDiscountString = [NSString stringWithFormat:@"%.1f折", [downModel.disCount floatValue]];
    [self setPrice:downPriceString discount:downDiscountString anotherModel:downModel priceLabel:self.downPriceLabel discountLabel:self.downDiscountLabel];
}

#pragma mark -- 赋值价格和折扣的方法  --
- (void)setPrice:(NSString *)price discount:(NSString *)discount anotherModel:(anotherModel *)model priceLabel:(UILabel *)priceLabel discountLabel:(UILabel *)discountLabel
{
    // 判断字符串中是否包含"."返回一个BOOL值
    BOOL isPrice = [price rangeOfString:@"."].location != NSNotFound;
    // 判断字符串的结尾是否包含".0折"返回一个BOOL值
    BOOL isDiscount = [discount hasSuffix:@".0折"];
    
    if (isPrice && isDiscount){
        priceLabel.text = [NSString stringWithFormat:@"¥ %.1f", [model.NewPrice floatValue]];
        discountLabel.text = [discount stringByReplacingOccurrencesOfString:@".0折" withString:@"折"];
    }
    else if (isPrice && (!isDiscount)){
        priceLabel.text = [NSString stringWithFormat:@"¥ %.1f", [model.NewPrice floatValue]];
        discountLabel.text = discount;
    }
    else if ((!isPrice) && isDiscount) {
        priceLabel.text = [NSString stringWithFormat:@"¥ %@", price];
        discountLabel.text = [discount stringByReplacingOccurrencesOfString:@".0折" withString:@"折"];
    }
    else {
        priceLabel.text = [NSString stringWithFormat:@"¥ %@", price];
        discountLabel.text = discount;
    }
}

@end
