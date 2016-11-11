//
//  QTRefreshView.m
//  QTRefresh
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "QTRefreshView.h"
typedef enum {
    RefreshViewStatusNormal,
    RefreshViewStatusPulling,
    RefreshViewStatusRefreshing
} RefreshViewStatus;

#define RefreshViewHeight 60

@interface QTRefreshView()

/** 图片 */
@property (nonatomic,strong) UIImageView  *imageView;

/** 文字 */
@property (nonatomic,strong) UILabel  *label;

/** 记录父控件 */
@property (nonatomic,strong) UIScrollView  *superScrollView;

/** 记录当前状态 */
@property (nonatomic,assign) RefreshViewStatus currentStatus;

/** 动画图片数组 */
@property (nonatomic,strong) NSArray  *refreshImages;



@end

@implementation QTRefreshView

#pragma mark - 懒加载
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
        [self addSubview: _label];
        _label.textColor = [UIColor darkGrayColor];
        _label.font =[UIFont systemFontOfSize:16.0f];
    }
    return _label;
}

-(NSArray *)refreshImages{
    if(!_refreshImages){
        NSMutableArray *arrM = [NSMutableArray array];
        for (int i = 1; i<=3; i++) {
            NSString *name = [NSString stringWithFormat:@"rabbit_loading%d",i];
            [arrM addObject:[UIImage imageNamed:name]];
        }
        //构造好数组后再赋值
        _refreshImages = arrM.mutableCopy;
    }
    return _refreshImages;

}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imageView.frame = CGRectMake(120, 5, 50, 50);
        self.label.frame = CGRectMake(190, 20, 100, 30);
        self.currentStatus = RefreshViewStatusNormal;
    }
    return self;
}

#pragma  mark - 获得父控件
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.superScrollView = (UIScrollView*)newSuperview;
        
        //监听属性改变
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"父控件滚动：%f",self.superScrollView.contentOffset.y);
    if (self.superScrollView.isDragging) {
        
        CGFloat offsetY = self.superScrollView.contentOffset.y;
        CGFloat normalPullOffset = -124; // -60 - 64导航栏高度 = -124全部显示出来的时候
        if (offsetY > normalPullOffset && self.currentStatus == RefreshViewStatusPulling) {
        // -90 > -124
//            NSLog(@"切换到normal状态");
            self.currentStatus = RefreshViewStatusNormal;
        }else if(offsetY <= normalPullOffset && self.currentStatus == RefreshViewStatusNormal){
//          NSLog(@"切换到Pulling状态");
            self.currentStatus = RefreshViewStatusPulling;
        }
    }else{
        if (self.currentStatus == RefreshViewStatusPulling){
            self.currentStatus = RefreshViewStatusRefreshing;
        }
    }
   
}

-(void)setCurrentStatus:(RefreshViewStatus)currentStatus{
    _currentStatus = currentStatus;
    switch (currentStatus) {
        case RefreshViewStatusNormal:
        {
            [self.imageView stopAnimating];
            self.label.text = @"下拉刷新";
            self.imageView.image = [UIImage imageNamed:@"rabbit_cry"];
            self.superScrollView.contentInset = UIEdgeInsetsMake(RefreshViewHeight, 0, 0, 0);
            break;
        }
        case RefreshViewStatusPulling:
        {
            self.label.text = @"释放刷新";
            self.imageView.image = [UIImage imageNamed:@"rabbit_loading_error_white"];
            break;
        }
        case RefreshViewStatusRefreshing:
        {
            self.label.text = @"正在刷新。。。";
            self.imageView.animationImages = self.refreshImages;
            self.imageView.animationDuration = self.refreshImages.count * 0.1;
            [self.imageView startAnimating];
            //动画移动
            [UIView animateWithDuration:0.25 animations:^{
                self.superScrollView.contentInset = UIEdgeInsetsMake(RefreshViewHeight*2,
                                                                     self.superScrollView.contentInset.left,
                                                                     self.superScrollView.contentInset.bottom,
                                                                     self.superScrollView.contentInset.right);
            }];
            
            //block 回调
            !self.refreshBlock ?: self.refreshBlock();
            break;
        }
        default:
            break;
    }

}

-(void)endRefresh{
    self.currentStatus = RefreshViewStatusNormal;
}

-(void)beginRefresh:(void(^)())refreshBlock{
    self.refreshBlock = refreshBlock;
}

@end
