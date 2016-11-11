//
//  PullDownToRefreshView.h
//  自定义下拉刷新
//
//  Created by Qinting on 2016/11/11.
//  Copyright © 2016年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownToRefreshView : UIView

@property (nonatomic,copy) void(^refreshingBlock)();

-(void)addRefresh:(void(^)())refreshBlock;

-(void)beginRefresh;

-(void)endRefresh;

@end
