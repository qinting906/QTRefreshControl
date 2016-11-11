//
//  PullDownToRefreshView.m
//  自定义下拉刷新
//
//  Created by Qinting on 2016/11/11.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "PullDownToRefreshView.h"

#define PullDownToRefreshViewHeight 60
typedef enum {
    PullDownToRefreshViewStatusNormal,
    PullDownToRefreshViewStatusPulling,
    PullDownToRefreshViewStatusRefreshing
} PullDownToRefreshViewStatus;


@interface PullDownToRefreshView ()

//图片
@property (nonatomic,strong) UIImageView  *imageView;

// 文字
@property (nonatomic,strong) UILabel  *label;

// 记录状态
@property (nonatomic,assign) PullDownToRefreshViewStatus currentStatu;

// 记录可以滚动的父控件
@property (nonatomic,strong) UIScrollView  *superScrollView;

//加载图片的数组
@property (nonatomic,strong) NSArray  *refreshImages;
@end

@implementation PullDownToRefreshView

/** 懒加载 */
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rabbit_loading1"]];
    }
    return _imageView;
}

-(UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc]init];
        _label.textColor = [UIColor darkGrayColor];
        _label.text = @"下拉刷新";
        _label.font = [UIFont systemFontOfSize:16.0f];
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
        _refreshImages = arrM.mutableCopy;
    }
    return _refreshImages;
}

/** 1.初始化的时候添加控件 */
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        // TODO : 设置frame
        self.imageView.frame = CGRectMake(130, 5, 50, 50);
        self.label.frame = CGRectMake(200, 20, 100, 30);
    }
    return self;
}
/** 2. [self.tableView addSubview:refreshView];时会调用此方法，然后通过此方法获取到父控件，
    然后监听父控件的滚动,注意要先判断父控件是能滚动的才去监听 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]){
        self.superScrollView = (UIScrollView*)newSuperview;
        //3.监听父控件的滚动,其实就是用KVO监听self.superScrollView 的contentOffset属性的变化
        // addObserver : 谁来监听
        //forKeyPath : 监听的哪个属性
        // 注意： KVO 要移除，否则报错
        [self.superScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    NSLog(@"======%@===%f",change[@"new"],self.superScrollView.contentOffset.y);
    /** 
     根据拖动的程度切换状态
     手拖动： Normal -> pulling, pulling-> normal
     手松开：pulling -> refreshing
     */
    if(self.superScrollView.isDragging){
//    手拖动： Normal -> pulling, pulling-> normal
        CGFloat normalPullingOffset = -124;  // 64 + 60
        CGFloat offsetY = self.superScrollView.contentOffset.y;
        if(self.currentStatu == PullDownToRefreshViewStatusPulling && offsetY > normalPullingOffset){  // -90 > -124
            NSLog(@"切换到normal状态");
            self.currentStatu = PullDownToRefreshViewStatusNormal;
        }else if(self.currentStatu == PullDownToRefreshViewStatusNormal && offsetY <= normalPullingOffset){  // -150 < -124 越往下拉动，offsetY值越小
            NSLog(@"切换到Pulling状态");
            self.currentStatu = PullDownToRefreshViewStatusPulling;
        }
    }else{
//    手松开：pulling -> refreshing 从拉拽状态 到 刷新状态
        if(self.currentStatu == PullDownToRefreshViewStatusPulling){
            self.currentStatu = PullDownToRefreshViewStatusRefreshing;
        }
    }
}

-(void)setCurrentStatu:(PullDownToRefreshViewStatus)currentStatu{
    _currentStatu = currentStatu;
    switch (currentStatu) {
        case PullDownToRefreshViewStatusNormal:
            self.label.text = @"下拉刷新";
            self.imageView.image = [UIImage imageNamed:@"rabbit_cry"];
            self.superScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            break;
        case PullDownToRefreshViewStatusPulling:
            self.label.text = @"释放刷新";
            self.imageView.image = [UIImage imageNamed:@"rabbit_loading_error_white"];
            break;
        case PullDownToRefreshViewStatusRefreshing:
        {
            self.label.text = @"正在刷新...";
            
            // 动画
            self.imageView.animationImages = self.refreshImages;
            self.imageView.animationDuration = self.refreshImages.count * 0.1;
            [self.imageView startAnimating];
            
            NSLog(@"%f",self.superScrollView.contentInset.left);
            
            //tableView 下移
            [UIView animateWithDuration:0.25 animations:^{
            self.superScrollView.contentInset = UIEdgeInsetsMake(PullDownToRefreshViewHeight*2,
                                                          self.superScrollView.contentInset.left,
                                                          self.superScrollView.contentInset.bottom,
                                                          self.superScrollView.contentInset.right);
            }];
            break;
        }
        default:
            break;
    }
}


-(void)dealloc{
    [self.superScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
