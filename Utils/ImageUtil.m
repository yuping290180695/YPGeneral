//
//  ImageUtil.m
//  CanXinTong
//
//  Created by 喻平 on 13-3-7.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil
+ (UIImage *)scaleImage:(UIImage *)image byWidth:(CGFloat)width
{
    UIGraphicsBeginImageContext(CGSizeMake(width, image.size.height * width / image.size.width));
    [image drawInRect:CGRectMake(0, 0, width, image.size.height * width / image.size.width)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)scaleImage:(UIImage *)image byHeight:(CGFloat)height
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * height / image.size.height, height));
    [image drawInRect:CGRectMake(0, 0, image.size.width * height / image.size.height, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (UIImage *)stretchableImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

+ (UIImage *)stretchableImage:(NSString *)imageName height:(CGFloat)height
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:height];
}

+ (UIImage *)resizableImage:(NSString *)imageName withInsets:(UIEdgeInsets )insets
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image resizableImageWithCapInsets:insets];
}
@end
