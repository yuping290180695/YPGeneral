//
//  HttpUtil.h
//  CanXinTong
//
//  Created by 喻平 on 13-3-18.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"
#import "YPBaseViewController.h"
#import "ApiRequest.h"
//typedef enum {
//    HttpMethodPost,
//    HttpMethodGet,
//    HttpMethodPut,
//    HttpMethodDelete,
//}HttpMethod;



@interface HttpUtil : NSObject

@property (nonatomic, strong) MKNetworkEngine *engine;
@property (nonatomic, strong) NSDictionary *errorDict;
+ (HttpUtil *)shared;
// icarsclub的http请求，需要signed request
- (void)startPPRequest:(NSString *)path
                      params:(NSMutableDictionary *)params
                  httpMethod:(NSString *)method
                  controller:(YPBaseViewController *)controller
                   successed:(void (^)(NSDictionary *data))sBlock
                      failed:(BOOL (^)(NSDictionary *responseDict))fBlock;

- (void)startPPRequest:(NSString *)path
                      params:(NSMutableDictionary *)params
                  httpMethod:(NSString *)method
                  controller:(YPBaseViewController *)controller
                   successed:(void (^)(NSDictionary *data))sBlock;

- (void)startPPRequest:(NSString *)path
                      params:(NSMutableDictionary *)params
                  httpMethod:(NSString *)method
                   completed:(MKNKResponseBlock)response
                       error:(MKNKResponseErrorBlock)error;

- (void)uploadFile:(NSString *)path
            params:(NSMutableDictionary *)params
        dataParams:(NSMutableDictionary *)data
        controller:(YPBaseViewController *)controller
          progress:(MKNKProgressBlock)pBlock
         successed:(void (^)(NSDictionary *data))sBlock
            failed:(BOOL (^)(NSDictionary *responseDict))fBlock;

// http请求，通用
- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method
                controller:(YPBaseViewController *)controller
                 successed:(void (^)(NSDictionary *data))sBlock
                    failed:(BOOL (^)(NSDictionary *responseDict))fBlock;

- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method
                 completed:(MKNKResponseBlock)response
                     error:(MKNKResponseErrorBlock)error;
+ (NSString *)requestUrlWithPath:(NSString *)path;

- (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller;
- (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller success:(void (^)(NSDictionary *data))sBlock;
- (void)process:(MKNetworkOperation *)request
     controller:(YPBaseViewController *)controller
        success:(void (^)(NSDictionary *data))sBlock
         failed:(BOOL (^)(NSDictionary *responseDict))fBlock;


//
//+ (void)startWithURLStr:(NSString *)urlString
//                 params:(NSMutableDictionary *)params
//                 method:(NSString *)method
//             controller:(YPBaseViewController *)controller
//              successed:(ApiRequestSuccessedBlock)successed
//                 failed:(ApiRequestFailedBlock)failed;
@end

