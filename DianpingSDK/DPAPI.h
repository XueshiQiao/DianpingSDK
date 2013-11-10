//
//  DPAPI.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

#define DPAPIBaseURLString          @"http://api.dianping.com/v1/"
#define DPAppKey                    @"45285573"
#define DPAppSecret                 @"a405ee607aa345fca4cd8256618e9f38"

@interface DPAPI : AFHTTPSessionManager

+ (instancetype)sharedAPI;
+ (NSDictionary *)signedParamsWithParmas:(NSDictionary *)params;
+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;

@end
