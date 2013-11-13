//
//  ApiRequest.h
//  iCarsClub
//
//  Created by 喻平 on 13-11-12.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YPBaseViewController.h"
#import "MKNetworkKit.h"

#define HttpMethodPost     @"POST"
#define HttpMethodGet      @"GET"
#define HttpMethodPut      @"PUT"
#define HttpMethodDelete   @"DELETE"
typedef void (^ApiRequestSuccessedBlock)(NSDictionary *successedData);
typedef BOOL (^ApiRequestFailedBlock)(NSDictionary *failedData);

@interface ApiRequest : NSObject
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) NSMutableDictionary *params;
@property (nonatomic, strong) NSMutableDictionary *uploadFiles;
@property (nonatomic, strong) YPBaseViewController *controller;
@property (nonatomic, strong) ApiRequestSuccessedBlock successed;
@property (nonatomic, strong) ApiRequestFailedBlock failed;


- (id)initWithPath:(NSString *)path
            params:(NSMutableDictionary *)params
        httpMethod:(NSString *)method
        controller:(YPBaseViewController *)controller;

- (id)initWithUrlString:(NSString *)urlString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method
             controller:(YPBaseViewController *)controller;
- (void)start;
- (void)startUpload;
- (void)setSuccessedHandler:(ApiRequestSuccessedBlock)successed
              failedHandler:(ApiRequestFailedBlock)failed;
- (void)onUploadProgressChanged:(MKNKProgressBlock)uploadProgressBlock;

// 关闭进度框并且显示错误信息
- (void)hideProgressAndShowErrorMsg:(NSString *)message;
/*
 子类可重写
 */
// 组装请求的URL
+ (NSString *)requestUrlWithPath:(NSString *)path;

// 获取错误信息
- (NSString *)getErrorMessage:(NSDictionary *)responseData;

// 请求成功如何操作
- (void)operationSuccessed:(NSDictionary *)responseData;

// 请求失败如何操作
- (void)operationFailed:(NSDictionary *)responseData;
@end

@interface HttpEngine : NSObject

@property (nonatomic, strong) MKNetworkEngine *mkNetworkEngine;
+ (HttpEngine *)sharedInstance;
@end
