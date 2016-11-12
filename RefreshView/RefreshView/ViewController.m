//
//  ViewController.m
//  RefreshView
//
//  Created by Qinting on 2016/11/12.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "ViewController.h"
#import "PullDownToRefreshView.h"

@interface ViewController ()

@property (nonatomic,strong) NSArray  *allCities;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allCities = [self loadData];
    
    CGRect rFrame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    PullDownToRefreshView* refreshView = [[PullDownToRefreshView alloc]initWithFrame:rFrame];
    refreshView.backgroundColor = [UIColor brownColor];
    [self.tableView addSubview:refreshView];
    [refreshView beginRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{            
            NSMutableArray *arrM = [NSMutableArray array];
            [arrM addObjectsFromArray:[self loadData]];
            [arrM addObjectsFromArray:self.allCities];
            self.allCities = arrM.copy;
            [self.tableView reloadData];
            
            [refreshView endRefresh];
        });
    }];
    
}


-(NSArray *)loadData{
    return @[@"beijing",@"shanghai",@"nanjing"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCities.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.allCities[indexPath.row];
    return cell;
}

@end
