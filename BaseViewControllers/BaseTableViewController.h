//
//  BaseTableViewController.h
//  CanXinTong
//
//  Created by 喻平 on 13-1-28.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPBaseViewController.h"

@interface BaseTableViewController : YPBaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tableViewDataSource;
}
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableViewDataSource;
- (void)initTableViewDataSource;
- (void)generateTextFieldCell:(UITableViewCell *)cell placeHolder:(NSString *)holder;
@end
