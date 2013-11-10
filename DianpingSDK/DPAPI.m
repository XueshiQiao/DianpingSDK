//
//  DPAPI.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPAPI.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation DPAPI

+ (instancetype)sharedAPI
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:DPAPIBaseURLString]];
        [sharedInstance setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return sharedInstance;
}

+ (NSDictionary *)signedParamsWithParmas:(NSDictionary *)params
{
    NSMutableDictionary *signedParams = params ? [params mutableCopy] : [NSMutableDictionary dictionary];
    [signedParams setObject:DPAppKey forKey:@"appkey"];
    
    NSMutableString *paramString = [NSMutableString string];
    [paramString appendString:DPAppKey];
    
    NSArray *sortedKeys = [params.allKeys sortedArrayUsingComparator:^(NSString *key1, NSString *key2){
        return [key1 compare:key2 options:NSCaseInsensitiveSearch];
    }];

    for (NSString *key in sortedKeys) {
        id obj = params[key];
        NSString *stringValue;
        if ([obj isKindOfClass:[NSString class]]) {
            stringValue = obj;
        }
        else {
            if ([obj respondsToSelector:@selector(stringValue)]) {
                stringValue = [obj stringValue];
            }
            else {
                stringValue = [obj description];
            }
        }
        
        [paramString appendFormat:@"%@%@", key, stringValue];
    }
    
    [paramString appendString:DPAppSecret];
    
    NSString *sha1EncodedString = [self SHA1EncodedStringWithString:paramString];
    NSString *sign = [sha1EncodedString uppercaseString];
    [signedParams setObject:sign forKey:@"sign"];
    
    return signedParams;
}

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : message ? message : @""};
    return [[NSError alloc] initWithDomain:@"DPAPIError" code:code userInfo:userInfo];
}

#pragma mark - Private

+ (NSString *)SHA1EncodedStringWithString:(NSString *)plainString
{
    NSData *data = [plainString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        
    CC_SHA1(data.bytes, data.length, digest);
        
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
        
    return result;
}

@end
