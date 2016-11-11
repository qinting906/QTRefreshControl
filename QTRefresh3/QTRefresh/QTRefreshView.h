//
//  QTRefreshView.h
//  QTRefresh
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTRefreshView : UIView

@property (nonatomic,strong) void(^refreshBlock)();

-(void)beginRefresh:(void(^)())refreshBlock;

-(void)endRefresh;

@end
