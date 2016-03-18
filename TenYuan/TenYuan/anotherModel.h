//
//  anotherModel.h
//  WorthAround
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface anotherModel : NSObject

@property (nonatomic, strong) NSString *ProductImg;//图片
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSNumber *NewPrice;
@property (nonatomic, strong) NSNumber *oldPrice;
@property (nonatomic, strong) NSNumber *disCount;
@property (nonatomic, assign) BOOL IsBaoYou;

@end
