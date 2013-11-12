//
//  HttpProcessor.h
//  TouZiBao
//
//  Created by 喻平 on 13-1-14.
//  Copyright (c) 2013年 喻平. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YPBaseViewController.h"

@class MKNetworkOperation;
@interface HttpProcessor : NSObject

+ (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller;
+ (void)process:(MKNetworkOperation *)request controller:(YPBaseViewController *)controller success:(void (^)(NSDictionary *data))sBlock;
+ (void)process:(MKNetworkOperation *)request
     controller:(YPBaseViewController *)controller
        success:(void (^)(NSDictionary *data))sBlock
         failed:(BOOL (^)(NSDictionary *responseDict))fBlock;
@end
