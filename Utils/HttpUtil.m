//
//  HttpUtil.m
//  CanXinTong
//
//  Created by 喻平 on 13-3-18.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "HttpUtil.h"
#import "Constants.h"
#import "JSONKit.h"
#import "AccountManager.h"
@interface HttpUtil ()
{
    
}

@end


@implementation HttpUtil
@synthesize engine;

- (id)init
{
    self = [super init];
    if (self) {
        self.engine = [[MKNetworkEngine alloc] initWithHostName:nil];
        self.errorDict = [NativeUtil dictionaryWithPlistFile:@"error_codes"];
//        NSLog(@"error dict-->%@", _errorDict.description);
    }
    return self;
}

+ (HttpUtil *)shared
{
    static HttpUtil *httpUtil = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpUtil = [[HttpUtil alloc] init];
    });
    return httpUtil;
}

- (void)startPPRequest:(NSString *)path
                params:(NSMutableDictionary *)params
            httpMethod:(HttpMethod)method
             completed:(MKNKResponseBlock)response
                 error:(MKNKResponseErrorBlock)error
{
    NSString *url = [self requestUrlWithPath:path params:params];
    if (method == HttpMethodGet) {
        NSString *getUrl = [url stringByAppendingFormat:@"%@%@", params.count > 0 ? @"&": @"", [HttpUtil requestValue:params]];
        [self startWithURLString:getUrl
                          params:nil
                      httpMethod:method
                       completed:response
                           error:error];
    } else {
        [self startWithURLString:url params:params httpMethod:method completed:response error:error];
    }
}

- (void)startPPRequest:(NSString *)path
                params:(NSMutableDictionary *)params
            httpMethod:(HttpMethod)method
            controller:(YPBaseViewController *)controller
             successed:(void (^)(NSDictionary *data))sBlock
{
    [self startPPRequest:path
                  params:params
              httpMethod:method
              controller:controller
               successed:sBlock
                  failed:nil];
}

- (void)startPPRequest:(NSString *)path
                params:(NSMutableDictionary *)params
            httpMethod:(HttpMethod)method
            controller:(YPBaseViewController *)controller
             successed:(void (^)(NSDictionary *data))sBlock
                failed:(BOOL (^)(NSDictionary *responseDict))fBlock
{
    
    NSString *url = [self requestUrlWithPath:path params:params];
    if (method == HttpMethodGet) {
        NSString *getUrl = [url stringByAppendingFormat:@"%@%@", params.count > 0 ? @"&": @"", [HttpUtil requestValue:params]];
        [self startWithURLString:getUrl
                          params:nil
                      httpMethod:method
                      controller:controller
                       successed:sBlock
                          failed:fBlock];
    } else {
        [self startWithURLString:url
                          params:params
                      httpMethod:method
                      controller:controller
                       successed:sBlock
                          failed:fBlock];
    }
}





- (void)uploadFile:(NSString *)path
            params:(NSMutableDictionary *)params
        dataParams:(NSMutableDictionary *)data
        controller:(YPBaseViewController *)controller
          progress:(MKNKProgressBlock)pBlock
         successed:(void (^)(NSDictionary *data))sBlock
            failed:(BOOL (^)(NSDictionary *responseDict))fBlock
{
    NSString *url = [self requestUrlWithPath:path params:params];
    MKNetworkOperation *op = [engine operationWithURLString:url params:params httpMethod:@"POST"];
//    [op addHeader:@"Content-Type" withValue:@"multipart/form-data"];
    NSArray *keys = [data allKeys];
    for (NSString *key in keys) {
        [op addData:data[key] forKey:key mimeType:@"multipart/form-data" fileName:@"file.jpg"];
        NSLog(@"%@--->%d", key, [(NSData *)data[key] length]);
//        NSObject *obj = data[key];
//        if ([obj isKindOfClass:[NSString class]]) {
//            [op addFile:(NSString *)obj forKey:key];
//            NSLog(@"key-->%@ path-->%@", key, obj);
//        } else {
//            NSData *uData = data[key];
//            [op addData:uData forKey:key mimeType:@"multipart/form-data" fileName:@"file"];
//            NSLog(@"key-->%@ data length-->%d", key, [(NSData *)obj length]);
//        }
    }
    NSLog(@"url-->%@", url);
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self process:completedOperation
           controller:controller
              success:sBlock
               failed:fBlock];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self process:completedOperation
           controller:controller
              success:sBlock
               failed:fBlock];
    }];
    [op onUploadProgressChanged:pBlock];
    [engine enqueueOperation:op forceReload:YES];
}


- (NSString *)requestUrlWithPath:(NSString *)path params:(NSMutableDictionary *)params
{
    NSString *accessToken = [AccountManager accessToken];
    NSString *value = [HttpUtil requestValue:params sort:[path isEqualToString:HTTP_PATH_USER_RESET_PASSWORD]];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                          (__bridge CFStringRef)value,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@+$,/ ?%#[]",
                                                                                          kCFStringEncodingUTF8);
    
    NSString *beforeMD5Value = [encodedValue stringByAppendingString:@"Q-)nA~c]#DBM&*-p"];
    NSLog(@"end url encode-->%@", beforeMD5Value);
    NSString *md5 = [beforeMD5Value md5];
    
    NSString *url = [HttpUtil requestUrlWithPath:path];
    if (accessToken) {
        return [url stringByAppendingFormat:@"?access_token=%@&signed_request=%@", accessToken ? accessToken : @"", md5];
    } else {
        return [url stringByAppendingFormat:@"?signed_request=%@", md5];
    }
}

+ (NSString *)requestUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@", HOST_NAME, path];
}
+ (NSString *)requestValue:(NSMutableDictionary *)dictionary
{
    return [HttpUtil requestValue:dictionary sort:NO];
}

+ (NSString *)requestValue:(NSMutableDictionary *)dictionary sort:(BOOL)sort
{
    
    if (!dictionary) {
        return nil;
    }

    NSArray *keys = [dictionary allKeys];
    if (sort) {
        NSLog(@"sort-->%d", sort);
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
        keys = [[dictionary allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    int count = [keys count];
    
    NSMutableString *requestString = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        NSString *key = keys[i];
        NSString *value = [dictionary objectForKey:key];
        if (value != nil) {
            [requestString appendFormat:@"%@=%@", key, value];
            if (i < count - 1) {
                [requestString appendFormat:@"&"];
            }
        }
    }
    NSLog(@"requestString-->%@", requestString);
    return requestString;
}

- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(HttpMethod)method
                controller:(YPBaseViewController *)controller
                 successed:(void (^)(NSDictionary *data))sBlock
                    failed:(BOOL (^)(NSDictionary *responseDict))fBlock
{
    [self startWithURLString:urlString
                      params:params
                  httpMethod:method
                   completed:^(MKNetworkOperation *completedOperation) {
                       [self process:completedOperation
                                   controller:controller
                                      success:sBlock
                                       failed:fBlock];
                   }
                       error:^(MKNetworkOperation *completedOperation, NSError *error) {
                           [self process:completedOperation
                                       controller:controller
                                          success:nil
                                           failed:fBlock];
                       }];
}

- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(HttpMethod)method
                 completed:(MKNKResponseBlock)response
                     error:(MKNKResponseErrorBlock)error
{
    NSString *httpMethod = nil;
    switch (method) {
        case HttpMethodGet:
            httpMethod = @"GET";
            break;
        case HttpMethodDelete:
            httpMethod = @"DELETE";
            break;
        case HttpMethodPost:
            httpMethod = @"POST";
            break;
        case HttpMethodPut:
            httpMethod = @"PUT";
            break;
            
        default:
            break;
    }
    NSLog(@"url-->%@", urlString);
    NSLog(@"method-->%@", httpMethod);
    NSLog(@"params-->%@", [params description]);
    
    MKNetworkOperation *op = [engine operationWithURLString:urlString params:params httpMethod:httpMethod];
    [op addCompletionHandler:response errorHandler:error];
    [engine enqueueOperation:op forceReload:YES];
}


- (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller
{
    [self process:request controller:controller success:nil];
}
- (void)process:(MKNetworkOperation *)request  controller:(YPBaseViewController *)controller success:(void (^)(NSDictionary *data))sBlock
{
    [self process:request controller:controller success:sBlock failed:nil];
}

- (void)process:(MKNetworkOperation *)request
     controller:(YPBaseViewController *)controller
        success:(void (^)(NSDictionary *data))sBlock
         failed:(BOOL (^)(NSDictionary *responseDict))fBlock
{
    if (controller && [controller isViewInBackground]) {
        return;
    }
    int status = request.HTTPStatusCode;
    NSLog(@"request code--->%d", status);
    NSString *result = [request responseString];
    NSDictionary *dict = [result objectFromJSONString];
    NSLog(@"result dict--->%@", dict.description);
    
    void (^failed)() = ^{
        if (fBlock && fBlock(dict)) return;
        NSString *code = dict[@"status"][@"code"];
        
        NSString *message = [_errorDict objectForKey:[NSString stringWithFormat:@"error_%@", code]];
        NSLog(@"code-->%@ message-->%@", code, message);
        if (message == nil) {
            message = dict[@"status"][@"message"];
        }
        if (message == nil) {
            NSString *error = dict[@"error"];
            if ([@"invalid_token" isEqualToString:error]) {
                if (controller) [controller hideProgress];
                [NativeUtil showAlertWithMessage:@"您上次的登录已失效，请重新登录"];
                return;
            }
        }
        if (controller) {
            [controller hideProgress];
            if (message) {
                NSLog(@"message length-->%d", [message charLength]);
                if ([message charLength] < 30) {
                    [controller showToast:message];
                    return;
                } else {
                    [NativeUtil showAlertWithMessage:message];
                }
            } else {
                [controller showToast:@"发现未知错误，请重试"];
            }
            
        } else {
            if (message) {
                [NativeUtil showAlertWithMessage:message];
            } else {
                [NativeUtil showAlertWithMessage:@"发现未知错误，请重试"];
            }
            
        }
    };
    if (status == 0 || dict == nil) {
        failed();
        return;
    }
    
    if (status == 200) {
        NSNumber *code = dict[@"status"][@"code"];
        if (code.intValue == 0) {
            NSDictionary *data = [dict objectForKey:@"data"];
            if (data) {
                if (sBlock) sBlock(data);
            } else {
                if (sBlock) sBlock(dict);
            }
            
        } else {
            failed();
        }
    } else {
        failed();
    }
}

+ (void)startWithURLStr:(NSString *)urlString
                 params:(NSMutableDictionary *)params
                 method:(NSString *)method
             controller:(YPBaseViewController *)controller
              successed:(ApiRequestSuccessedBlock)successed
                 failed:(ApiRequestFailedBlock)failed;
{
    ApiRequest *request = [[ApiRequest alloc] initWithUrlString:urlString
                                                         params:params
                                                     httpMethod:method
                                                     controller:controller];
    [request setSuccessedHandler:successed failedHandler:failed];
    [request start];
}

@end
@interface ApiRequest ()
@property (nonatomic, strong) ApiRequestSuccessedBlock successed;
@property (nonatomic, strong) ApiRequestFailedBlock failed;
@property (nonatomic, strong) MKNKProgressBlock uploadProgressBlock;
@end

@implementation ApiRequest

- (id)initWithPath:(NSString *)path
            params:(NSMutableDictionary *)params
        httpMethod:(NSString *)method
        controller:(YPBaseViewController *)controller
{
    return [self initWithUrlString:[ApiRequest requestUrlWithPath:path]
                            params:params
                        httpMethod:method
                        controller:controller];
}

- (id)initWithUrlString:(NSString *)urlString
                 params:(NSMutableDictionary *)params
             httpMethod:(NSString *)method
             controller:(YPBaseViewController *)controller
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.params = params;
        self.method = method;
        self.controller = controller;
    }
    return self;
}

- (void)start
{
    NSLog(@"url-->%@", self.urlString);
    NSLog(@"method-->%@", _method);
    NSLog(@"params-->%@", [self.params description]);
    
    MKNetworkEngine *engine = [HttpUtil shared].engine;
    MKNetworkOperation *op = [engine operationWithURLString:self.urlString
                                                     params:self.params
                                                 httpMethod:_method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self process:completedOperation];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self process:completedOperation];
    }];
    [engine enqueueOperation:op forceReload:YES];
}
/**
 文件上传
 */
- (void)startUpload
{
    NSLog(@"url-->%@", self.urlString);
    NSLog(@"params-->%@", [self.params description]);
    
    MKNetworkEngine *engine = [HttpUtil shared].engine;
    MKNetworkOperation *op = [engine operationWithURLString:self.urlString
                                                     params:self.params
                                                 httpMethod:@"POST"];
    NSArray *keys = [_uploadFiles allKeys];
    for (NSString *key in keys) {
        NSObject *obj = _uploadFiles[key];
        if ([obj isKindOfClass:[NSString class]]) {
            [op addFile:(NSString *)obj forKey:key];
            NSLog(@"key-->%@ path-->%@", key, obj);
        } else {
            NSData *uData = _uploadFiles[key];
            [op addData:uData forKey:key];
            NSLog(@"key-->%@ data length-->%d", key, [(NSData *)obj length]);
        }
        //        [op addData:_uploadFiles[key] forKey:key mimeType:@"multipart/form-data" fileName:@"file.jpg"];
        //        NSLog(@"%@--->%d", key, [(NSData *)_uploadFiles[key] length]);
    }
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self process:completedOperation];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self process:completedOperation];
    }];
    [op onUploadProgressChanged:self.uploadProgressBlock];
    [engine enqueueOperation:op forceReload:YES];
}
- (void)onUploadProgressChanged:(MKNKProgressBlock)uploadProgressBlock
{
    self.uploadProgressBlock = uploadProgressBlock;
}
- (void)setSuccessedHandler:(ApiRequestSuccessedBlock)successed failedHandler:(ApiRequestFailedBlock)failed
{
    self.successed = successed;
    self.failed = failed;
}

- (void)process:(MKNetworkOperation *)request;
{
    if (_controller && [_controller isViewInBackground]) {
        return;
    }
    int status = request.HTTPStatusCode;
    NSLog(@"request code--->%d", status);
    NSString *result = [request responseString];
    NSDictionary *dict = [result objectFromJSONString];
    NSLog(@"result dict--->%@", dict.description);
    
    void (^failed)() = ^{
        if (_failed && _failed(dict)) return;
        NSString *code = dict[@"status"][@"code"];
        
        NSString *message = [[HttpUtil shared].errorDict objectForKey:[NSString stringWithFormat:@"error_%@", code]];
        NSLog(@"code-->%@ message-->%@", code, message);
        if (message == nil) {
            message = dict[@"status"][@"message"];
        }
        if (message == nil) {
            NSString *error = dict[@"error"];
            if ([@"invalid_token" isEqualToString:error]) {
                if (_controller) [_controller hideProgress];
                [NativeUtil showAlertWithMessage:@"您上次的登录已失效，请重新登录"];
                return;
            }
        }
        if (_controller) {
            [_controller hideProgress];
            if (message) {
                NSLog(@"message length-->%d", [message charLength]);
                if ([message charLength] < 30) {
                    [_controller showToast:message];
                    return;
                } else {
                    [NativeUtil showAlertWithMessage:message];
                }
            } else {
                [_controller showToast:@"发现未知错误，请重试"];
            }
            
        } else {
            if (message) {
                [NativeUtil showAlertWithMessage:message];
            } else {
                [NativeUtil showAlertWithMessage:@"发现未知错误，请重试"];
            }
            
        }
    };
    if (status == 0 || dict == nil) {
        failed();
        return;
    }
    
    if (status == 200) {
        NSNumber *code = dict[@"status"][@"code"];
        if (code.intValue == 0) {
            NSDictionary *data = [dict objectForKey:@"data"];
            if (data) {
                if (_successed) _successed(data);
            } else {
                if (_successed) _successed(dict);
            }
            
        } else {
            failed();
        }
    } else {
        failed();
    }
}

+ (NSString *)requestUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@", HOST_NAME, path];
}

// 这两个方法只在pp租车应用里面使用
- (NSString *)requestUrlWithPath:(NSString *)path params:(NSMutableDictionary *)params
{
    NSString *accessToken = [AccountManager accessToken];
    NSString *value = [self requestValue:params sort:[path isEqualToString:HTTP_PATH_USER_RESET_PASSWORD]];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *encodedValue = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                          (__bridge CFStringRef)value,
                                                                                          NULL,
                                                                                          (CFStringRef)@"!*'();:@+$,/ ?%#[]",
                                                                                          kCFStringEncodingUTF8);
    
    NSString *beforeMD5Value = [encodedValue stringByAppendingString:@"Q-)nA~c]#DBM&*-p"];
    NSLog(@"end url encode-->%@", beforeMD5Value);
    NSString *md5 = [beforeMD5Value md5];
    
    NSString *url = [ApiRequest requestUrlWithPath:path];
    if (accessToken) {
        return [url stringByAppendingFormat:@"?access_token=%@&signed_request=%@", accessToken ? accessToken : @"", md5];
    } else {
        return [url stringByAppendingFormat:@"?signed_request=%@", md5];
    }
}

- (NSString *)requestValue:(NSMutableDictionary *)dictionary sort:(BOOL)sort
{
    
    if (!dictionary) {
        return nil;
    }
    
    NSArray *keys = [dictionary allKeys];
    if (sort) {
        NSLog(@"sort-->%d", sort);
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:YES];
        keys = [[dictionary allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    }
    int count = [keys count];
    
    NSMutableString *requestString = [NSMutableString string];
    for (int i = 0; i < count; i++) {
        NSString *key = keys[i];
        NSString *value = [dictionary objectForKey:key];
        if (value != nil) {
            [requestString appendFormat:@"%@=%@", key, value];
            if (i < count - 1) {
                [requestString appendFormat:@"&"];
            }
        }
    }
    NSLog(@"requestString-->%@", requestString);
    return requestString;
}
@end
