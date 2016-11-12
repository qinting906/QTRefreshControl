//
//  PullDownToRefreshView.m
//  RefreshView
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "PullDownToRefreshView.h"

typedef enum {
    PullDownToRefreshViewStatusNormal,
    PullDownToRefreshViewStatusPulling,
    PullDownToRefreshViewStatusRefreshing
} PullDownToRefreshViewStatus;

#define PullDownToRefreshViewHeight 60


@interface PullDownToRefreshView ()

@property (nonatomic,strong) void(^RefreshBlock)();

@property (nonatomic,strong) UIImageView  *imageView;
@property (nonatomic,strong) UILabel  *label;

@property (nonatomic,strong) UIScrollView  *superScrollView;

@property (nonatomic,assign) PullDownToRefreshViewStatus currentStatus;
@property (nonatomic,strong) NSArray *refreshImages;

@end

@implementation PullDownToRefreshView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rabbit_cry"]];
        [self addSubview:_imageView];
    }
    return _imageView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = [UIFont systemFontOfSize:16.0f];
        _label.textColor = [UIColor darkGrayColor];
        [self addSubview:_label];
    }
    return  _label;
}

-(NSArray *)refreshImages{
    if (_refreshImages == nil) {
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 1; i<=3; i++) {
            NSString *str=  [NSString stringWithFormat:@"rabbit_loading%d",i];
            [arrM addObject:[UIImage imageNamed:str]];
        }
        _refreshImages = arrM.copy;
    }
    return _refreshImages;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.frame = CGRectMake(130, 5, 50, 50);
        self.label.frame = CGRectMake(190, 20, 100, 30);
        
    }
    return self;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView*)newSuperview;
        
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

    if(self.superScrollView.isDragging){
        CGFloat offsetY = self.superScrollView.contentOffset.y;
        CGFloat normalContentOffsetY = -124;
        if (self.currentStatus == PullDownToRefreshViewStatusPulling
            && offsetY > normalContentOffsetY) {
            self.currentStatus = PullDownToRefreshViewStatusNormal;
        }else if(self.currentStatus == PullDownToRefreshViewStatusNormal
                 && offsetY <= normalContentOffsetY){
            self.currentStatus = PullDownToRefreshViewStatusPulling;
        }
    }else if(self.currentStatus == PullDownToRefreshViewStatusPulling){
        self.currentStatus = PullDownToRefreshViewStatusRefreshing;
    }
}

-(void)setCurrentStatus:(PullDownToRefreshViewStatus)currentStatus{
    _currentStatus = currentStatus;
    switch (currentStatus) {
        case PullDownToRefreshViewStatusNormal:
        {
            [self.imageView stopAnimating];
            self.imageView.image = [UIImage imageNamed:@"rabbit_cry"];
            self.label.text = @"下拉刷新";
            self.superScrollView.contentInset = UIEdgeInsetsMake( PullDownToRefreshViewHeight,0,0,0);
          break;
        }
            
        case PullDownToRefreshViewStatusPulling:
        {
            self.imageView.image = [UIImage imageNamed:@"rabbit_loading_error_white"];
            self.label.text = @"释放刷新";
            break;
        }
          
        case PullDownToRefreshViewStatusRefreshing:
        {
            self.label.text = @"正在刷新....";
            self.imageView.animationImages = self.refreshImages;
            self.imageView.animationDuration = 0.1*self.refreshImages.count;
            [self.imageView startAnimating];
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(
                                                     PullDownToRefreshViewHeight +
                                                     self.superScrollView.contentInset.top
                                                     , self.superScrollView.contentInset.left,
                                                     self.superScrollView.contentInset.bottom,
                                                     self.superScrollView.contentInset.right);
            }];
            
            // block
            !self.RefreshBlock ?: self.RefreshBlock();
            
            break;
        }
            
        default:
            break;
    }

}

-(void)beginRefresh:(void(^)())refreshBlock{
    self.RefreshBlock = refreshBlock;
}

-(void)endRefresh{
    self.currentStatus = PullDownToRefreshViewStatusNormal;
}


@end
