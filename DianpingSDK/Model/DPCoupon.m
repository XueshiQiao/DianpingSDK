//
//  DPCoupon.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPCoupon.h"
#import "DPAPI.h"
#import "DPBusiness.h"

@implementation DPCoupon

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        
        _couponID = [attributes[@"coupon_id"] integerValue];
        _title = attributes[@"title"];
        _desc = attributes[@"description"];
        _regions = attributes[@"regions"];
        _categories = attributes[@"categories"];
        _downloadCount = [attributes[@"download_count"] integerValue];
        _publishDate = attributes[@"publish_date"];
        _expirationDate = attributes[@"expiration_date"];
        _distance = [attributes[@"distance"] integerValue];
        _logoImgURL = attributes[@"logo_img_url"];
        _couponURL = attributes[@"coupon_h5_url"];
        
        NSMutableArray *businesses = [NSMutableArray array];
        for (NSDictionary *businessAttributes in attributes[@"businesses"]) {
            DPBusiness *business = [[DPBusiness alloc] init];
            business.businessID = [businessAttributes[@"id"] integerValue];
            business.name = businessAttributes[@"name"];
            business.businessURL = businessAttributes[@"h5_url"];
            [businesses addObject:business];
        }
        _businesses = businesses;
    }
    
    return self;
}

+ (NSURLSessionDataTask *)couponsWithParams:(NSDictionary *)params
                                      block:(void (^)(NSArray *, NSError *))block
{
    return [[DPAPI sharedAPI] GET:@"coupon/find_coupons"
                       parameters:[DPAPI signedParamsWithParmas:params]
                          success:^(NSURLSessionDataTask * __unused task, id JSON) {
                              int errorCode = [JSON[@"error"][@"errorCode"] intValue];
                              if (errorCode) {
                                  NSLog(@"Error: %@", JSON[@"error"][@"errorMessage"]);
                                  
                                  if (block) {
                                      block(nil, [DPAPI errorWithCode:errorCode message:JSON[@"error"][@"errorMessage"]]);
                                  }
                                  
                                  return;
                              }
                              
                              NSArray *couponsFromResponse = JSON[@"coupons"];
                              NSMutableArray *coupons = [NSMutableArray array];
                              
                              for (NSDictionary *attributes in couponsFromResponse) {
                                  DPCoupon *coupon = [[DPCoupon alloc] initWithAttributes:attributes];
                                  [coupons addObject:coupon];
                              }
                              
                              if (block) {
                                  block(coupons, nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

+ (NSURLSessionDataTask *)couponWithID:(NSInteger)couponID
                                 block:(void (^)(DPCoupon *, NSError *))block
{
    NSDictionary *params = @{@"coupon_id" : couponID ? @(couponID) : @0};
    
    return [[DPAPI sharedAPI] GET:@"coupon/get_single_coupon"
                       parameters:[DPAPI signedParamsWithParmas:params]
                          success:^(NSURLSessionDataTask * __unused task, id JSON) {
                              int errorCode = [JSON[@"error"][@"errorCode"] intValue];
                              if (errorCode) {
                                  NSLog(@"Error: %@", JSON[@"error"][@"errorMessage"]);
                                  
                                  if (block) {
                                      block(nil, [DPAPI errorWithCode:errorCode message:JSON[@"error"][@"errorMessage"]]);
                                  }
                                  
                                  return;
                              }
                              
                              NSArray *couponsFromResponse = JSON[@"coupons"];
                              DPCoupon *coupon;
                              
                              for (NSDictionary *attributes in couponsFromResponse) {
                                  coupon = [[DPCoupon alloc] initWithAttributes:attributes];
                                  break;
                              }
                              
                              if (block) {
                                  block(coupon, nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

@end
