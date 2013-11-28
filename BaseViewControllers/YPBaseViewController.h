//
//  YPBaseViewController.h
//  CanXinTong
//
//  Created by 喻平 on 13-1-28.
//  Copyright (c) 2013年 喻平. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface YPBaseViewController : UIViewController <MBProgressHUDDelegate>
{
    BOOL _keyboardNotiEnabled;
}
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;

// 显示等待框
- (void)hideProgress;
- (void)showWhiteProgressWithText:(NSString *)text;
- (void)showProgressWithText:(NSString *)text;
- (void)showProgressOnWindowWithText:(NSString *)text;
- (void)showProgressOnView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled;

// 显示Toast消息
- (void)showToast:(NSString *)text onView:(UIView *)view inCenter:(BOOL)inCenter hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)text inCenter:(BOOL)inCenter;
- (void)showToast:(NSString *)text;

// 判断view是不是正在显示
- (BOOL)isViewInBackground;

// 根据名字跳转View Controller
- (void)pushViewControllerWithName:(NSString *)name;

// 键盘通知
- (void)setKeyboardNotificationEnabled:(BOOL)enabled;
- (void)keyboardWillShowWithRect:(CGRect)keyboardRect animationDuration:(float)duration;
- (void)keyboardWillHideWithRect:(CGRect)keyboardRect animationDuration:(float)duration;

// 点击背景，关闭键盘，用于会弹出键盘的View Controller
- (void)addBackgroundButtonForHidingKeybord;

// 定制导航按钮
- (void)initLeftBarButtonItem:(NSString *)title;
- (void)initRightBarButtonItem:(NSString *)title;
- (void)initLeftBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
- (void)initRightBarButtonItem:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

- (IBAction)rightBarButtonPressed:(id)sender;
- (IBAction)leftBarButtonPressed:(id)sender;
@end
