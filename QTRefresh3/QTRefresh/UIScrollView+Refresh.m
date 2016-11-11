//
//  UIScrollView+Refresh.m
//  QTRefresh
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

@implementation UIScrollView (Refresh)

-(void)setQt_header:(UIView *)qt_header{
    if (qt_header != self.qt_header) {
        // 删除旧的头部view
        [self.qt_header removeFromSuperview];
        [self insertSubview:qt_header atIndex:0];
        
        // 存储新的header view
        [self willChangeValueForKey:@"qt_header"];
        objc_setAssociatedObject(self, @"qt_header", qt_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"qt_header"];
    }

}

-(UIView *)qt_header{
    return objc_getAssociatedObject(self, @"qt_header");
}

@end
