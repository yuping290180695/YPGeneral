//
//  UIHelper.m
//  iCarsClub
//
//  Created by yuping on 13-7-10.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "UIHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@implementation UIHelper
+ (void)showToast:(NSString *)text onView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay {
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
    //	hud.margin = 10.f;
    //	hud.yOffset = view.frame.size.height * 0.2f;
	hud.removeFromSuperViewOnHide = YES;
	hud.userInteractionEnabled = NO;
	[hud hide:YES afterDelay:delay];
}

+ (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [UIHelper showToast:text onView:delegate.window hideAfterDelay:delay];
}

+ (void)showToast:(NSString *)text
{
    [UIHelper showToast:text hideAfterDelay:2.0f];
}

+ (void)displayDatePicker:(UIViewController *)controller button:(UIButton *)button
{
    
}
@end
