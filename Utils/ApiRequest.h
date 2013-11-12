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
+ (NSString *)requestUrlWithPath:(NSString *)path;

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


@end
