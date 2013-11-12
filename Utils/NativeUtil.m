//
//  Util.m
//  NBD
//
//  Created by Tai Jason on 12-9-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "CommonCrypto/CommonDigest.h"
#import "NativeUtil.h"

@implementation NativeUtil
+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
+ (CGSize)sizeOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
}

+ (CGFloat)singleLineHeightOfText:(NSString *)text font:(UIFont *)font
{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(1000000, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
}

+ (NSString *)stringWithValue:(id)value
{
    if (!value) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@", value];
}



+ (BOOL)isStringEmpty:(NSString *)string
{
    if (string == nil) {
        return YES;
    }
    if ([string length] == 0) {
        return YES;
    }
    return NO;
}
+ (BOOL)isArrayEmpty:(NSArray *)array
{
    if (array == nil || [array count] == 0) {
        return YES;
    }
    return NO;
}

+ (void)setUILabelFont:(UILabel *)label size:(CGFloat)size
{
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:size];
    label.shadowOffset = CGSizeMake(0, 1);
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.298039 green:0.337255 blue:0.423529 alpha:1.000];
}

+ (BOOL)isStringMatchRegex:(NSString *)string regex:(NSString *)regex
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:string]) {
        return YES;
    }
    return NO;
}

+ (void)udSetObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}

+ (id)udObjectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
+ (void)showAlertWithTitle:(NSString *)title
{
    [NativeUtil showAlertWithTitle:title okButtonTitle:@"关闭"];
}

+ (void)showAlertWithTitle:(NSString *)title okButtonTitle:(NSString *)okButtonTitle
{
    [NativeUtil showAlertWithTitle:title
                           message:nil
                        completion:nil
                 cancelButtonTitle:nil
                 otherButtonTitles:okButtonTitle, nil];
}

+ (void)showAlertWithMessage:(NSString *)message
{
    [NativeUtil showAlertWithMessage:message completion:nil cancelButtonTitle:@"关闭" okButtonTitle:nil];
}

+ (void)showAlertWithMessage:(NSString *)message
             okButtonClicked:(void (^)())okButtonClicked
{
    [NativeUtil showAlertWithMessage:message
                          completion:^(NSInteger buttonIndex) {
                              if (buttonIndex == 1 && okButtonClicked) {
                                  okButtonClicked();
                              }
                          }
                   cancelButtonTitle:@"取消"
                       okButtonTitle:@"确定"];
}

+ (void)showAlertWithMessage:(NSString *)message
                  completion:(void (^)(NSInteger buttonIndex))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
               okButtonTitle:(NSString *)okButtonTitle
{
    [NativeUtil showAlertWithTitle:@"提示"
                           message:message
                        completion:completion
                 cancelButtonTitle:cancelButtonTitle
                 otherButtonTitles:okButtonTitle, nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                  completion:(void (^)(NSInteger buttonIndex))completion
           cancelButtonTitle:(NSString *)cancelButtonTitle
           otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:otherButtonTitles, nil];
    [alert showWithCompletionHandler:completion];
}

+ (CGSize)resizeCGSize:(CGSize)size maxWidth:(CGFloat)maxWidth maxHeight:(CGFloat)maxHeight
{
    if (size.width * maxHeight / maxWidth >= size.height) {
        if (size.width > maxWidth) {
            return CGSizeMake(maxWidth, maxWidth * size.height / size.width);
        } else {
            return size;
        }
    } else {
        if (size.height > maxHeight) {
            return CGSizeMake(maxHeight * size.width / size.height, maxHeight);
        } else {
            return size;
        }
    }
}

+ (CGSize)resizeCGSize:(CGSize)size minHeight:(CGFloat)minHeight
{
    return CGSizeMake(minHeight * size.width / size.height, minHeight);
}

+ (CGSize)resizeCGSize:(CGSize)size minWidth:(CGFloat)minWidth
{
    return CGSizeMake(minWidth * size.height / size.width, minWidth);
}
+ (void)hideKeyboard
{
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (BOOL)isPositiveIntNumber:(NSString *)string
{
    if ([NativeUtil isStringEmpty:string]) {
        return YES;
    }
    return [NativeUtil isStringMatchRegex:string regex:REGEX_POSITIVE_INT];
}

+ (BOOL)isPositiveNumber:(NSString *)string
{
    if ([NativeUtil isStringEmpty:string]) {
        return YES;
    }
    return [NativeUtil isStringMatchRegex:string regex:REGEX_POSITIVE_NUMBER];
}

+ (BOOL)isIdNumber:(NSString *)string
{
    if ([NativeUtil isStringMatchRegex:string regex:REGEX_ID_NUMBER]) {
        return YES;
    }
    return NO;
}
+ (NSArray *)arrayWithPlistFile:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}
+ (NSDictionary *)dictionaryWithPlistFile:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (void)call:(NSString *)phoneNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
}

+ (NSString *)appVersionName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSInteger)appVersionCode
{
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] integerValue];
}

@end

@implementation NSSet (NSSetEXT)

- (NSArray *)sortedArrayByKey:(NSString *)key
{
    return [self sortedArrayByKey:key ascending:YES];
}

- (NSArray *)sortedArrayByKey:(NSString *)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:key ascending:ascending];
    return [self sortedArrayUsingDescriptors:@[sort]];
}

- (NSArray *)sortedArrayByKeys:(NSArray *)keys
{
    NSMutableArray *sorts = [NSMutableArray array];
    for (NSString *key in keys) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:key ascending:YES];
        [sorts addObject:sort];
    }
    return [self sortedArrayUsingDescriptors:sorts];
}

@end

@implementation NSNumber (NSNumberEXT)

- (NSString *)toString
{
    if ([@"0" isEqualToString:self.stringValue]) {
        return @"";
    } else {
        return self.stringValue;
    }
}
@end

@implementation NSString (NSStringEXT)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
- (CGSize)sizeWithLabelWidth:(CGFloat)width andFont:(UIFont *)font;
{
    return [self sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
}

- (NSString *)URLEncodedString
{
    return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                    (__bridge CFStringRef)self,
                                                                                    NULL,
                                                                                    CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                    kCFStringEncodingUTF8);
}

- (NSUInteger)charLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [self lengthOfBytesUsingEncoding:enc];
}

@end


@implementation UIImage (UIImageEXT)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self imageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
