//
//  RefreshTableViewController.h
//  iCarsClub
//
//  Created by 喻平 on 13-8-1.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PullToFooterRefreshView.h"
@interface RefreshTableViewController : BaseTableViewController
{
    int _page;
    int _total;
}
@property (nonatomic, strong) PullToFooterRefreshView *pullToRefreshFooterView;
@property (nonatomic, assign) BOOL pullToFootRefreshEnabled;


- (void)tableViewPullToFootLoadDataWillStart;
- (void)tableViewPullToFootLoadDataFinished;
@end
