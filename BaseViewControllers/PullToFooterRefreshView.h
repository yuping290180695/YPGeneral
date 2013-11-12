//
//  PullToFooterRefreshView.h
//  iCarsClub
//
//  Created by yuping on 13-8-3.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullToFooterRefreshView : UIView


@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, assign, readonly) BOOL isAnimating;
- (void)startAnimating;
- (void)stopAnimating;
@end
