//
//  BrandSaleHorCell.m
//  WorthAround
//
//  Created by lanou on 15/11/15.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "BrandSaleHorCell.h"
#import "Define.h"

@implementation BrandSaleHorCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWith/4, 50)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 45, kScreenWith/4, 3)];
        self.view.backgroundColor = kMycolor;
        [self.contentView addSubview:self.view];
    }
    return self;
}

@end
