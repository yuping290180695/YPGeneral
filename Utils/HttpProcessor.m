//
//  HttpProcessor.m
//  TouZiBao
//
//  Created by 喻平 on 13-1-14.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import "HttpProcessor.h"
#import "JSONKit.h"

#import "AppDelegate.h"
#import "MKNetworkKit.h"
@implementation HttpProcessor
+ (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller
{
    [HttpProcessor process:request controller:controller success:nil];
}
+ (void)process:(MKNetworkOperation *)request  controller:(YPBaseViewController *)controller success:(void (^)(NSDictionary *data))sBlock
{
    [HttpProcessor process:request controller:controller success:sBlock failed:nil];
}

+ (void)process:(MKNetworkOperation *)request
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
        NSString *message = dict[@"status"][@"message"];
        if (message == nil) {
            message = dict[@"error_description"];
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
                [controller showToast:@"网络请求失败，请稍后再试"];
            }
            
        } else {
            if (message) {
                [NativeUtil showAlertWithMessage:message];
            } else {
                [NativeUtil showAlertWithMessage:@"网络请求失败，请稍后再试"];
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

@end
