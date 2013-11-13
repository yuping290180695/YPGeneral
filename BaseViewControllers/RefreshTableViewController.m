//
//  RefreshTableViewController.m
//  iCarsClub
//
//  Created by 喻平 on 13-8-1.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "RefreshTableViewController.h"

@interface RefreshTableViewController ()
{

}
@end

@implementation RefreshTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pullToFootRefreshEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_pullToFootRefreshEnabled) {
        return;
    }
    if (tableView.tableFooterView) {
        return;
    }

    if (indexPath.row == tableViewDataSource.count - 1) {
        NSLog(@"last count-->%d  total-->%d", [tableViewDataSource count], _total);
        if (self.pullToRefreshFooterView == nil) {
            NSLog(@"pullToRefreshFooterView init");
            self.pullToRefreshFooterView = [[PullToFooterRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        }
        if (tableViewDataSource.count < _total) {
            [_pullToRefreshFooterView startAnimating];
            [self tableViewPullToFootLoadDataWillStart];
        } else {
            [_pullToRefreshFooterView stopAnimating];
        }
        self.tableView.tableFooterView = _pullToRefreshFooterView;
    }
}

#pragma mark -
#pragma mark Pull to foot of table view Refresh Methods
- (void)tableViewPullToFootLoadDataWillStart
{
    
}

- (void)tableViewPullToFootLoadDataFinished
{
    NSLog(@"finished");
    self.tableView.tableFooterView = nil;
//    [UIView animateWithDuration:0.25
//                     animations:^{
//                         self.tableView.tableFooterView = nil;
//                     }];
    
}

@end
