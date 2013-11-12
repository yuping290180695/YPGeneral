//
//  PullToFooterRefreshView.m
//  iCarsClub
//
//  Created by yuping on 13-8-3.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "PullToFooterRefreshView.h"

@implementation PullToFooterRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initContent];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initContent
{
//    self.frame = CGRectMake(0, 0, 320, 40);
    
    self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake((int) ((self.bounds.size.width - 120) / 2), 0, 40, 40);
    [self addSubview:_indicatorView];
    
    self.textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textAlignment = UITextAlignmentCenter;
    [self addSubview:_textLabel];
    
    [self startAnimating];
}

- (void)startAnimating
{
    if (_isAnimating) {
        return;
    }
    _isAnimating = YES;
    [_indicatorView startAnimating];
    _textLabel.frame = CGRectMake(_indicatorView.frame.origin.x + _indicatorView.frame.size.width, 0, 80, 40);
    _textLabel.text = @"正在加载...";
}

- (void)stopAnimating
{
    if (!_isAnimating) {
        return;
    }
    _isAnimating = NO;
    [_indicatorView stopAnimating];
    _textLabel.frame = CGRectMake(0, 0, self.bounds.size.width, 40);
    _textLabel.text = @"没有更多数据了";
}

@end
