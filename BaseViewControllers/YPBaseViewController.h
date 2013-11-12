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
- (void)hideProgress;
- (void)showWhiteProgressWithText:(NSString *)text;
- (void)showProgressWithText:(NSString *)text;
- (void)showProgressOnWindowWithText:(NSString *)text;
- (void)showProgressOnView:(UIView *)view text:(NSString *)text userInteractionEnabled:(BOOL)enabled;


- (void)showToast:(NSString *)text onView:(UIView *)view inCenter:(BOOL)inCenter hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
- (void)showToast:(NSString *)text inCenter:(BOOL)inCenter;
- (void)showToast:(NSString *)text;

- (BOOL)isViewInBackground;
- (void)pushViewControllerWithName:(NSString *)name;
- (void)keyboardWillShowWithRect:(CGRect)keyboardRect;
- (void)keyboardWillHideWithRect:(CGRect)keyboardRect;
- (void)addBackgroundButtonForHidingKeybord;
@end
