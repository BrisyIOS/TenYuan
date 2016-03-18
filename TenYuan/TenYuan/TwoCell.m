//
//  TwoCell.m
//  WorthAround
//
//  Created by lanou on 15/12/2.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgView.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.imgView];
        
    }
    return self;
}

@end
