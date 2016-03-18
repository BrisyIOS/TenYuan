//
//  HomeUpCell.h
//  TenYuan
//
//  Created by lanou on 15/11/30.
//  Copyright (c) 2015年 zhangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

// scrollView的跳转协议
@protocol upTapDelegate <NSObject>

- (void)upTapDelegateWithActid:(NSInteger)actid catName:(NSString *)catName tName:(NSString *)tName;

@end
@protocol downTapDelegate <NSObject>
// 今日更新、手机、美食、美妆共用协议
- (void)downTapDelegatePassToSearchVcWithBc:(NSInteger)bc sc:(NSInteger)sc channel:(NSInteger)channel daynews:(NSString *)daynews actid:(NSInteger)actid detaiName:(NSString *)detailName;

@end
// 最后疯抢的协议
@protocol downLastSaleDelegate <NSObject>

- (void)downLastSale;

@end
// 更多的跳转协议
@protocol midMoreDelegate <NSObject>

- (void)midMoreDelegate;

@end
@interface HomeUpCell : UICollectionViewCell

@property (nonatomic, strong) id<upTapDelegate> upTapDelegate;
@property (nonatomic, strong) id<downTapDelegate> downTapDelegate;
@property (nonatomic, strong) id<downLastSaleDelegate> downLastSaleDelegate;
@property (nonatomic, strong) id<midMoreDelegate> midMoreDelegate;

@end
