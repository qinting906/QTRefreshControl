//
//  QTMainTableViewController.m
//  QTRefresh
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "QTMainTableViewController.h"
#import "QTRefreshView.h"
#import "UIScrollView+Refresh.h"

@interface QTMainTableViewController ()
@property (nonatomic,strong) NSArray  *allCities;
@end

@implementation QTMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCities = [self loadData];
    
    CGRect refreshFrame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    QTRefreshView *refreshView = [[QTRefreshView alloc]initWithFrame:refreshFrame];
    refreshView.backgroundColor = [UIColor brownColor];
    [self.view addSubview:refreshView];
    
    [refreshView beginRefresh:^{
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray * arrM = [NSMutableArray array];
            [arrM addObjectsFromArray:[self loadData]];
            [arrM addObjectsFromArray:self.allCities];
            self.allCities = arrM.copy;
            
            [self.tableView reloadData];
            
            [refreshView endRefresh];
        });
        
    }];
    
//    self.tableView.qt_header = [QTRefreshView ]
    
}

- (NSArray*)loadData {
    NSString *str0 = [NSString stringWithFormat:@"模拟数据--%d",arc4random_uniform(100)];
    NSString *str1 = [NSString stringWithFormat:@"模拟数据--%d",arc4random_uniform(100)];
    NSString *str2 = [NSString stringWithFormat:@"模拟数据--%d",arc4random_uniform(100)];
    return @[str0,str1,str2];
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.allCities[indexPath.row];
    return cell;
}

@end
