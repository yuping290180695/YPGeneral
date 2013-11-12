//
//  UIViewController+UIViewControllerEXT.m
//  TouZiBao
//
//  Created by 喻平 on 12-10-30.
//  Copyright (c) 2012年 喻平. All rights reserved.
//

#import "UIViewController+UIViewControllerEXT.h"
#import "ImageUtil.h"
#import "UIView+UIViewEXT.h"
#import "BlockUI.h"

@implementation UIViewController  (UIViewControllerEXT)

- (void)initLeftBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}
- (void)initRightBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:style target:target action:action];
}

- (void)initLeftBarButtonItem:(NSString *)title
{
    [self initLeftBarButtonItem:title style:UIBarButtonItemStyleBordered target:self action:@selector(leftBarButtonPressed:)];
}

- (void)initRightBarButtonItem:(NSString *)title
{
    [self initRightBarButtonItem:title style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonPressed:)];
}
- (void)initCustomBackButton
{
    if ([self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault]) {
        [self initCustomWhiteBackButton];
    } else {
        [self initCustomGrayBackButton];
    }
    
}

- (void)initCustomGrayBackButton
{
    [self initCustomLeftButtonWithImage:[UIImage imageNamed:@"btn-back-gray"] highlighted:nil];
}
- (void)initCustomWhiteBackButton
{
    [self initCustomLeftButtonWithImage:[UIImage imageNamed:@"icon-back"] highlighted:nil];
}

- (void)initCustomLeftButtonWithImage:(UIImage *)normal highlighted:(UIImage *)highlighted
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = IOS7_AND_LATER ? CGRectMake(-25, 0, 64, 44) : leftView.bounds;
    [button setImage:normal forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(leftBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:button];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
}

- (void)initCustomRightBarButtonWithTitle:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [button setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(rightBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (IBAction)rightBarButtonPressed:(id)sender
{
    
}

- (IBAction)leftBarButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNavigationBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 44);
    [button addTarget:self action:@selector(leftBarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"icon-back"] forState:UIControlStateNormal];
    [self.view addSubview:button];
}



@end
