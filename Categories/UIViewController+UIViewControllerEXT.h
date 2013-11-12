//
//  UIViewController+UIViewControllerEXT.h
//  ;
//
//  Created by 喻平 on 12-10-30.
//  Copyright (c) 2012年 喻平. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UIViewControllerEXT)

- (void)initLeftBarButtonItem:(NSString *)title;
- (void)initRightBarButtonItem:(NSString *)title;

- (void)initLeftBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
- (void)initRightBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

- (IBAction)rightBarButtonPressed:(id)sender;
- (IBAction)leftBarButtonPressed:(id)sender;

- (void)initCustomBackButton;
- (void)initCustomGrayBackButton;
- (void)initCustomWhiteBackButton;
- (void)initCustomLeftButtonWithImage:(UIImage *)normal highlighted:(UIImage *)highlighted;
- (void)initCustomRightBarButtonWithTitle:(NSString *)title;

- (void)addNavigationBackButton;
@end
