//
//  Util.h
//  NBD
//
//  Created by Tai Jason on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "BlockUI.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define YPLineBreakByCharWrapping NSLineBreakByCharWrapping
#else
#define YPLineBreakByCharWrapping UILineBreakModeCharacterWrap
#endif


#define REGEX_USERNAME @"([A-Z0-9a-z-]|[\\u4e00-\\u9fa5])+"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
#define REGEX_PHONE_NUMBER @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
#define REGEX_POSITIVE_INT @"^\\d+$"
#define REGEX_POSITIVE_NUMBER @"^(0|([1-9]\\d*))(\\.\\d+)?$"
#define REGEX_ID_NUMBER @"^(\\d{15}|\\d{17}[\\dx])$"
#define REGEX_NUMBER @"^[0-9]*$"
#define FloatNumber(num) [NSNumber numberWithFloat:(num)]
#define IntNumber(num) [NSNumber numberWithInt:(num)]

#define userDefaults [NSUserDefaults standardUserDefaults]

//#define delegate (AppDelegate *)[UIApplication sharedApplication].delegate
#define RGBColor(RED,GREEN,BLUE) [UIColor colorWithRed:RED/255.0f green:GREEN/255.0f blue:BLUE/255.0f alpha:1.0f]

@interface NativeUtil : NSObject

+ (AppDelegate *)appDelegate;
+ (CGSize)sizeOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (CGFloat)singleLineHeightOfText:(NSString *)text font:(UIFont *)font;
+ (NSString *)stringWithValue:(id)value;

+ (BOOL)isStringEmpty:(NSString *)string;
+ (BOOL)isArrayEmpty:(NSArray *)array;
+ (void)setUILabelFont:(UILabel *)label size:(CGFloat)size;
+ (BOOL)isStringMatchRegex:(NSString *)string regex:(NSString *)regex;

+ (void)udSetObject:(id)object forKey:(NSString *)key;
+ (id)udObjectForKey:(NSString *)key;

// UiAlertView的扩展方法
+ (void)showAlertWithTitle:(NSString *)title;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okButtonTitle:(NSString *)okButtonTitle;

+ (void)showAlertWithMessage:(NSString *)message;
+ (void)showAlertWithMessage:(NSString *)message
             okButtonClicked:(void (^)())okButtonClicked;
+ (void)showAlertWithMessage:(NSString *)message
                  completion:(void (^)(NSInteger buttonIndex))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
               okButtonTitle:(NSString *)okButtonTitle;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                completion:(void (^)(NSInteger buttonIndex))completion
         cancelButtonTitle:(NSString *)cancelButtonTitle
         otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;


+ (CGSize)resizeCGSize:(CGSize)size maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight;
+ (CGSize)resizeCGSize:(CGSize)size minHeight:(CGFloat)minHeight;
+ (CGSize)resizeCGSize:(CGSize)size minWidth:(CGFloat)minWidth;

+ (void)hideKeyboard;
+ (BOOL)isPositiveIntNumber:(NSString *)string;
+ (BOOL)isPositiveNumber:(NSString *)string;
+ (BOOL)isIdNumber:(NSString *)string;

+ (NSArray *)arrayWithPlistFile:(NSString *)name;
+ (NSDictionary *)dictionaryWithPlistFile:(NSString *)name;
+ (void)call:(NSString *)phoneNumber;

+ (NSString *)appVersionName;
+ (NSInteger)appVersionCode;

+ (void)showToast:(NSString *)text;
+ (void)showToast:(NSString *)text inCenter:(BOOL)inCenter;
+ (void)showToast:(NSString *)text inCenter:(BOOL)inCenter hideAfterDelay:(NSTimeInterval)delay;
@end

@interface NSSet (NSSetEXT)
- (NSArray *)sortedArrayByKey:(NSString *)key;
- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending;
- (NSArray *)sortedArrayByKeys:(NSArray *)keys;
@end

@interface NSNumber (NSNumberEXT)
- (NSString *)toString;
@end

@interface NSString (NSStringEXT)
/**
 MD5加密
 */
- (NSString *)md5;
/**
 根据UILabel的宽度和字体，获取字符串的size
 */
- (CGSize)sizeWithLabelWidth:(CGFloat)width andFont:(UIFont *)font;
- (NSString *)URLEncodedString;
- (NSUInteger)charLength;

@end

@interface UIImage (UIImageEXT)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
