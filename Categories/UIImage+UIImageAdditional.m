//
//  UIImage+UIImageAdditional.m
//  CanXinTong
//
//  Created by 喻平 on 13-2-1.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "UIImage+UIImageAdditional.h"

@implementation UIImage (UIImageAdditional)
- (UIImage *)scaledByWidth:(CGFloat)width
{
    UIGraphicsBeginImageContext(CGSizeMake(width, self.size.height * width / self.size.width));
    [self drawInRect:CGRectMake(0, 0, width, self.size.height * width / self.size.width)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;                       
}

- (UIImage *)scaledByHeight:(CGFloat)height
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * height / self.size.height, height));
    [self drawInRect:CGRectMake(0, 0, self.size.width * height / self.size.height, height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
