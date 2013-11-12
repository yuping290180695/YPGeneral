//
//  ApiRequest.m
//  iCarsClub
//
//  Created by 喻平 on 13-11-12.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "ApiRequest.h"
#import "JSONKit.h"
#import "Constants.h"
#import "HttpUtil.h"
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
    MKNetworkOperation *op = [engine operationWithURLString:self.urlString params:self.params httpMethod:_method];
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
@end

