//
//  ImageUtil.h
//  CanXinTong
//
//  Created by 喻平 on 13-3-7.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject
+ (UIImage *)scaleImage:(UIImage *)image byWidth:(CGFloat)width;
+ (UIImage *)scaleImage:(UIImage *)image byHeight:(CGFloat)height;

+ (UIImage *)stretchableImage:(NSString *)imageName;
+ (UIImage *)stretchableImage:(NSString *)imageName height:(CGFloat)height;
+ (UIImage *)resizableImage:(NSString *)imageName withInsets:(UIEdgeInsets )insets;
@end
