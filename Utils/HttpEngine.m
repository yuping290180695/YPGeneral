//
//  HttpEngine.m
//  iCarsClub
//
//  Created by 喻平 on 13-11-13.
//  Copyright (c) 2013年 iCarsclub. All rights reserved.
//

#import "HttpEngine.h"
#import "JSONKit.h"
#import "Constants.h"
@implementation HttpEngine
- (id)init
{
    self = [super init];
    if (self) {
        self.mkNetworkEngine = [[MKNetworkEngine alloc] initWithHostName:nil];
    }
    return self;
}

+ (HttpEngine *)shared
{
    static HttpEngine *httpEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpEngine = [[HttpEngine alloc] init];
    });
    return httpEngine;
}

- (void)startWithPath:(NSString *)path
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)method
           controller:(YPBaseViewController *)controller
            successed:(ApiRequestSuccessedBlock)successed
{
    [self startWithPath:path
                 params:params
             httpMethod:method
             controller:controller
              successed:successed
                 failed:nil];
}

- (void)startWithPath:(NSString *)path
               params:(NSMutableDictionary *)params
           httpMethod:(NSString *)method
           controller:(YPBaseViewController *)controller
            successed:(ApiRequestSuccessedBlock)successed
               failed:(ApiRequestFailedBlock)failed
{
    [self startWithURLString:[self requestUrlWithPath:path]
                      params:params
                  httpMethod:method
                  controller:controller
                   successed:successed
                      failed:failed];
}

- (void)startWithURLString:(NSString *)urlString
                    params:(NSMutableDictionary *)params
                httpMethod:(NSString *)method
                controller:(YPBaseViewController *)controller
                 successed:(ApiRequestSuccessedBlock)successed
                    failed:(ApiRequestFailedBlock)failed
{
    NSLog(@"HttpEngine url-->%@", urlString);
    NSLog(@"HttpEngine method-->%@", method);
    NSLog(@"HttpEngine params-->%@", [params description]);
    MKNetworkEngine *engine = [HttpEngine shared].mkNetworkEngine;
    MKNetworkOperation *op = [engine operationWithURLString:urlString params:params httpMethod:method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self processRequestOperation:completedOperation
                           controller:controller
                     successedHandler:successed
                        failedHandler:failed];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self processRequestOperation:completedOperation
                           controller:controller
                     successedHandler:successed
                        failedHandler:failed];
    }];
    [engine enqueueOperation:op forceReload:YES];
}

- (void)startApiRequest:(ApiRequest *)request
             controller:(YPBaseViewController *)controller
              successed:(ApiRequestSuccessedBlock)successed
                 failed:(ApiRequestFailedBlock)failed
{
    NSLog(@"HttpEngine url-->%@", request.urlString);
    NSLog(@"HttpEngine method-->%@", request.method);
    NSLog(@"HttpEngine params-->%@", request.params);
    MKNetworkEngine *engine = [HttpEngine shared].mkNetworkEngine;
    MKNetworkOperation *op = [engine operationWithURLString:request.urlString params:request.params httpMethod:request.method];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [self processRequestOperation:completedOperation
                           controller:controller
                     successedHandler:successed
                        failedHandler:failed];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [self processRequestOperation:completedOperation
                           controller:controller
                     successedHandler:successed
                        failedHandler:failed];
    }];
    
    if (request.uploadFileDatas) {
        for (UploadFile *file in request.uploadFileDatas) {
            NSLog(@"key-->%@  data length-->%d fileName-->%@  type-->%@", file.key, file.data.length, file.fileName, file.mimeType);
            [op addData:file.data
                 forKey:file.key
               mimeType:file.mimeType ? file.mimeType : @"application/octet-stream"
               fileName:file.fileName ? file.fileName : @"file"];
        }
    }
    
    if (request.uploadFilePaths) {
        for (UploadFile *file in request.uploadFileDatas) {
            NSLog(@"key-->%@  path-->%@ type-->%@", file.key, file.filePath, file.mimeType);
            [op addFile:file.filePath
                 forKey:file.key
               mimeType:file.mimeType ? file.mimeType : @"application/octet-stream"];
        }
    }
    
    if (request.uploadProgressBlock) {
        [op onUploadProgressChanged:request.uploadProgressBlock];
    }
    if (request.downloadProgressBlock) {
        [op onDownloadProgressChanged:request.downloadProgressBlock];
    }
    [engine enqueueOperation:op forceReload:YES];
}



- (void)processRequestOperation:(MKNetworkOperation *)operation
                     controller:(YPBaseViewController *)controller
               successedHandler:(ApiRequestSuccessedBlock)successed
                  failedHandler:(ApiRequestFailedBlock)failed;
{
    if (controller && [controller isViewInBackground]) {
        return;
    }
    int status = operation.HTTPStatusCode;
    NSString *responseString = [operation responseString];
    NSDictionary *responseData = [responseString objectFromJSONString];
    NSLog(@"request code--->%d", status);
    NSLog(@"result dict--->%@", responseData.description);
    
    if (status == 200) {
        [self operationSuccessed:responseData
                            controller:controller
                      successedHandler:successed
                         failedHandler:failed];
    } else {
        [self operationFailed:responseData controller:controller failedHandler:failed];
    }
}

- (NSString *)requestUrlWithPath:(NSString *)path
{
    return [NSString stringWithFormat:@"%@/%@", HOST_NAME, path];
}

- (NSString *)getErrorMessage:(NSDictionary *)responseData
{
    return nil;
}

- (void)operationSuccessed:(NSDictionary *)responseData
                controller:(YPBaseViewController *)controller
          successedHandler:(ApiRequestSuccessedBlock)successed
             failedHandler:(ApiRequestFailedBlock)failed
{
    
}

- (void)operationFailed:(NSDictionary *)responseData
             controller:(YPBaseViewController *)controller
          failedHandler:(ApiRequestFailedBlock)failed
{
    if (failed && failed(responseData)) return;
    NSString *message = [self getErrorMessage:responseData];
    [self hideProgressAndShowErrorMsg:message controller:controller];
}

- (void)hideProgressAndShowErrorMsg:(NSString *)message controller:(YPBaseViewController *)controller
{
    if (controller) {
        [controller hideProgress];
        if (message) {
            NSLog(@"message length-->%d", [message charLength]);
            if ([message charLength] < 30) {
                [NativeUtil showToast:message];
            } else {
                [NativeUtil showAlertWithMessage:message];
            }
        } else {
            [NativeUtil showToast:@"发现未知错误，请重试"];
        }
    } else {
        if (message) {
            [NativeUtil showAlertWithMessage:message];
        } else {
            [NativeUtil showAlertWithTitle:@"发现未知错误，请重试"];
        }
    }
}

@end

@implementation ApiRequest
- (id)initWithUrlString:(NSString *)urlString params:(NSMutableDictionary *)params method:(NSString *)method
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.params = params;
        self.method = method;
    }
    return self;
}
@end

@implementation UploadFile
- (id)initWithKey:(NSString *)key
             data:(NSData *)data
         mimeType:(NSString *)mimeType
         fileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        self.key = key;
        self.data = data;
        self.mimeType = mimeType;
        self.fileName = fileName;
    }
    return self;
}
- (id)initWithKey:(NSString *)key
         filePath:(NSString *)filePath
         mimeType:(NSString *)mimeType
{
    self = [super init];
    if (self) {
        self.key = key;
        self.filePath = filePath;
        self.mimeType = mimeType;
    }
    return self;
}
@end
