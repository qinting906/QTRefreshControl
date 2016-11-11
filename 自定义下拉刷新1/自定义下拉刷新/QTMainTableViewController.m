//
//  QTMainTableViewController.m
//  自定义下拉刷新
//
//  Created by Qinting on 2016/11/11.
//  Copyright © 2016年 QT. All rights reserved.
//

#import "QTMainTableViewController.h"
#import "PullDownToRefreshView.h"

@interface QTMainTableViewController ()
@property (nonatomic,strong) NSArray  *allCities;
@end

@implementation QTMainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allCities = [self loadData];
    
    CGRect refreshFrame = CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60);
    PullDownToRefreshView *refreshView  = [[PullDownToRefreshView alloc]initWithFrame:refreshFrame];
//    refreshView.backgroundColor = [UIColor brownColor];
    [self.tableView addSubview:refreshView];
    [refreshView addRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 加载数据
            NSArray *newData = [self loadData];
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:newData];
            [arrayM addObjectsFromArray:self.allCities]; // 在旧数据前面添加新数据
            self.allCities = arrayM;
            
            [self.tableView reloadData];
            //结束刷新
            [refreshView  endRefresh];
        });
    }];
    [refreshView beginRefresh];

}

-(NSArray *)loadData{
   return @[@"beijing",@"shanghai",@"shenzhen"];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allCities.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.allCities[indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
