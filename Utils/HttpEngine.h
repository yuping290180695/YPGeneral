//
//  HttpEngine.h
//  iCarsClub
//
//  Created by 喻平 on 13-11-13.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
#import "YPBaseViewController.h"

#define HttpMethodPost     @"POST"
#define HttpMethodGet      @"GET"
#define HttpMethodPut      @"PUT"
#define HttpMethodDelete   @"DELETE"
typedef void (^ApiRequestSuccessedBlock)(NSDictionary *successedData);
typedef BOOL (^ApiRequestFailedBlock)(NSDictionary *failedData);


@interface HttpEngine : NSObject
@property (nonatomic, strong) MKNetworkEngine *mkNetworkEngine;
+ (HttpEngine *)shared;

- (void)startWithPath:(NSString *)path
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)method
           controller:(YPBaseViewController *)controller
            successed:(ApiRequestSuccessedBlock)successed;

- (void)startWithPath:(NSString *)path
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)method
           controller:(YPBaseViewController *)controller
            successed:(ApiRequestSuccessedBlock)successed
               failed:(ApiRequestFailedBlock)failed;

- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method
                controller:(YPBaseViewController *)controller
                 successed:(ApiRequestSuccessedBlock)successed
                    failed:(ApiRequestFailedBlock)failed;


// 显示提示信息
- (void)hideProgressAndShowErrorMsg:(NSString *)message controller:(YPBaseViewController *)controller;

/*
 子类需重写的方法，视情况而定
 */

// 根据path组装请求的url
- (NSString *)requestUrlWithPath:(NSString *)path;

// 请求失败时，获取错误信息
- (NSString *)getErrorMessage:(NSDictionary *)responseData;

// 请求成功的处理方法
- (void)operationSuccessed:(NSDictionary *)responseData
                controller:(YPBaseViewController *)controller
          successedHandler:(ApiRequestSuccessedBlock)successed
             failedHandler:(ApiRequestFailedBlock)failed;

// 请求失败的处理方法
- (void)operationFailed:(NSDictionary *)responseData
             controller:(YPBaseViewController *)controller
          failedHandler:(ApiRequestFailedBlock)failed;

@end


