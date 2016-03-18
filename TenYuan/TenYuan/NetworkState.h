//
//  NetworkState.h
//  17UILessonGetRequest
//
//  Created by lanou on 15/10/20.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkState : NSObject
// 此类为判断网络的类，专门判断网络状态，是无网络、移动网络、WiFi网络；判断网络状态有可能是每一个类（界面）都会使用的，所以进行封装并且成为单例，方便每一个界面使用
+ (NetworkState *)shareInstance;

// 判断网络状态的;这个方法是基于第三方 Reachability返回值是一个bool类型，NO没有网络，YES有网络
- (BOOL)reachability;

@end























