//
//  BrandSaleVerModel.h
//  WorthAround
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "anotherModel.h"

@interface BrandSaleVerModel : NSObject

@property (nonatomic, strong) NSNumber *brandId;//"brandId": 404618
@property (nonatomic, strong) NSString *EndDate;//"EndDate": "/Date(1448899140000+0800)/"
@property (nonatomic, strong) NSString *EndDateStr;//"EndDateStr": "2015-11-30 23:59:00"
@property (nonatomic, strong) NSString *ImgUrlSml;//"/upload/brand/201511160925484374.jpg"
@property (nonatomic, strong) NSNumber *DisCount;//"DisCount": 4.69999980926514
@property (nonatomic, copy) NSString *Name;//"Name": "南波旺特卖"
@property (nonatomic, copy) NSString *ProductInfo;
@property (nonatomic, strong) anotherModel *anotherModel;
@property (nonatomic, strong) NSMutableArray *array;

@end
