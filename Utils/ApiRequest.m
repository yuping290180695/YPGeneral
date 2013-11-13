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

@interface ApiRequest ()

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
    
    MKNetworkEngine *engine = [HttpEngine sharedInstance].mkNetworkEngine;
    MKNetworkOperation *op = [engine operationWithURLString:self.urlString params:self.params httpMethod:_method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self processRequestOperation:completedOperation];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self processRequestOperation:completedOperation];
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
    
    MKNetworkEngine *engine = [HttpEngine sharedInstance].mkNetworkEngine;
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
        [self processRequestOperation:completedOperation];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self processRequestOperation:completedOperation];
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

- (void)processRequestOperation:(MKNetworkOperation *)operation;
{
    if (_controller && [_controller isViewInBackground]) {
        return;
    }
    int status = operation.HTTPStatusCode;
    NSString *responseString = [operation responseString];
    NSDictionary *responseData = [responseString objectFromJSONString];
    NSLog(@"request code--->%d", status);
    NSLog(@"result dict--->%@", responseData.description);
    if (status == 200) {
        [self operationSuccessed:responseData];
    } else {
        [self operationFailed:responseData];
    }
}

+ (NSString *)requestUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@", HOST_NAME, path];
}

- (NSString *)getErrorMessage:(NSDictionary *)responseData
{
    return nil;
}

- (void)operationSuccessed:(NSDictionary *)responseData
{
    
}

- (void)operationFailed:(NSDictionary *)responseData
{
    if (_failed && _failed(responseData)) return;
    NSString *message = [self getErrorMessage:responseData];
    [self hideProgressAndShowErrorMsg:message];
}

- (void)hideProgressAndShowErrorMsg:(NSString *)message
{
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
}
@end

@implementation HttpEngine

- (id)init
{
    self = [super init];
    if (self) {
        self.mkNetworkEngine = [[MKNetworkEngine alloc] initWithHostName:nil];
//        self.errorDict = [NativeUtil dictionaryWithPlistFile:@"error_codes"];
        //        NSLog(@"error dict-->%@", _errorDict.description);
    }
    return self;
}

+ (HttpEngine *)sharedInstance
{
    static HttpEngine *httpEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpEngine = [[HttpEngine alloc] init];
    });
    return httpEngine;
}

@end

