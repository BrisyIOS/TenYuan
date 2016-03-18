//
//  NetworkState.m
//  17UILessonGetRequest
//
//  Created by lanou on 15/10/20.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import "NetworkState.h"
#import "Reachability.h"

@implementation NetworkState
+ (NetworkState *)shareInstance
{
    static NetworkState *state = nil;
    if (state == nil) {
        state = [[NetworkState alloc] init];
    }
    return state;
}

- (BOOL)reachability
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            return NO;
            break;
        case ReachableViaWWAN:
            NSLog(@"移动网络");
            return YES;
            break;
        case ReachableViaWiFi:
            NSLog(@"WIFI网络");
            return YES;
            break;
            
        default:
            break;
    }
}

@end



















