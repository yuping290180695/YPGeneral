//
//  UIView+UIViewEXT.m
//  CanXinTong
//
//  Created by 喻平 on 13-2-28.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "UIView+UIViewEXT.h"

@implementation UIView (UIViewEXT)
- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}
- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}
- (void)setX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}
- (void)setY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)centerInHorizontal:(UIView *)parentView
{
    [self setX:(parentView.width - self.width) / 2];
}

- (void)centerInVertical:(UIView *)parentView
{
    [self setY:(parentView.height - self.height) / 2];
}

- (void)setLocalizedTitleWithKey:(NSString *)key
{
    [(UIButton *)self setTitle:NSLocalizedString(key, nil) forState:UIControlStateNormal];
}

- (void)setLocalizedTextWithKey:(NSString *)key
{
    [(UILabel *)self setText:NSLocalizedString(key, nil)];
}
- (void)setLocalizedPlaceholderWithKey:(NSString *)key
{
    [(UITextField *)self setPlaceholder:NSLocalizedString(key, nil)];
}

@end
@implementation UILabel (UILabelEXT)

- (void)resizeHeightWithText
{
    CGSize size = [NativeUtil sizeOfText:self.text width:self.width font:self.font];
    
    self.height = ceil(size.height);
    NSLog(@"frame-->%@", NSStringFromCGRect(self.frame));
}

@end