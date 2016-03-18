//
//  WorthAroundVerModel.h
//  Another
//
//  Created by lanou on 15/11/14.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorthAroundVerModel : NSObject

@property (nonatomic, strong) NSString * ProductImgWX;//图片
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSNumber *NewPrice;
@property (nonatomic, strong) NSNumber *OldPrice;
@property (nonatomic, strong) NSNumber *Discount;
@property (nonatomic, assign) NSInteger SaleTotal;
@property (nonatomic, assign) BOOL IsBaoYou;
@property (nonatomic, strong) NSString *ProductUrl;

@end
