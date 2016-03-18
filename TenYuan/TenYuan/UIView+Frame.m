//
//  UIView+Frame.m
//  TenYuan
//
//  Created by lanou on 15/11/10.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

// 重写 x 的 set 和 get 方法
- (void)setX:(CGFloat)x
{
    CGFloat y = self.frame.origin.y;
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
// 重写 y 的 set 和 get 方法
- (void)setY:(CGFloat)y
{
    CGFloat x = self.frame.origin.x;
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
// 重写 width 的 set 和 get 方法
- (void)setWidth:(CGFloat)width
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat height = self.frame.size.height;
    self.frame = CGRectMake(x, y, width, height);
}
- (CGFloat)width
{
    return self.frame.size.width;
}
// 重写 height 的 set 和 get 方法
- (void)setHeight:(CGFloat)height
{
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    CGFloat width  = self.frame.size.width;
    self.frame = CGRectMake(x, y, width, height);
}
- (CGFloat)height
{
    return self.frame.size.height;
}



@end
