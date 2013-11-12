//
//  UIHelper.h
//  iCarsClub
//
//  Created by yuping on 13-7-10.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIHelper : NSObject
+ (void)showToast:(NSString *)text onView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay;

+ (void)showToast:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;

+ (void)showToast:(NSString *)text;
@end
