//
//  FileUtil.h
//  HuoQiuJiZhang
//
//  Created by 喻平 on 13-4-24.
//  Copyright (c) 2013年 com.huoqiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtil : NSObject
+ (BOOL)createDirectoryAtPath:(NSString *)path;
+ (BOOL)createFileAtPath:(NSString *)path;
+ (BOOL)createFileAtDirectory:(NSString *)directory fileName:(NSString *)fileName;
+ (BOOL)createDirectoryAtDocument:(NSString *)path;
+ (NSString *)documentDirectoryPath;
+ (BOOL)appendStringToFile:(NSString *)path string:(NSString *)string;
+ (NSString *)readStringFromFile:(NSString *)path;
@end
