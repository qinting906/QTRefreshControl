//
//  PullDownToRefreshView.h
//  RefreshView
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownToRefreshView : UIView



-(void)beginRefresh:(void(^)())refreshBlock;

-(void)endRefresh;

@end
