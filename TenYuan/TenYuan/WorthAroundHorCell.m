//
//  WorthAroundHorCell.m
//  WorthAround
//
//  Created by lanou on 15/11/14.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "WorthAroundHorCell.h"
#import "Define.h"

@implementation WorthAroundHorCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWith/5, 47)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 47, kScreenWith/5, 3)];
        self.view.backgroundColor = kMycolor;
        [self.contentView addSubview:self.view];
    }
    return self;
}

@end
