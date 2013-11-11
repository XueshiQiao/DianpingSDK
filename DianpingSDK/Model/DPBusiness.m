//
//  DPBusiness.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPBusiness.h"
#import "DPAPI.h"
#import "DPDeal.h"

@implementation DPBusiness

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    if (self == [super init]) {
        _businessID = [attributes[@"business_id"] integerValue];
        _name = attributes[@"name"];
        _branchName = attributes[@"branch_name"];
        _address = attributes[@"address"];
        _telephone = attributes[@"telephone"];
        _city = attributes[@"city"];
        _regions = attributes[@"regions"];
        _categories = attributes[@"categories"];
        _latitude = [attributes[@"latitude"] floatValue];
        _longitude = [attributes[@"longitude"] floatValue];
        _avgRating = [attributes[@"avg_rating"] floatValue];
        _ratingImgURL = attributes[@"rating_img_url"];
        _smallRatingImgURL = attributes[@"rating_s_img_url"];
        _productGrade = [attributes[@"product_grade"] integerValue];
        _decorationGrade = [attributes[@"decoration_grade"] integerValue];
        _serviceGrade = [attributes[@"service_grade"] integerValue];
        _avgPrice = [attributes[@"avg_price"] integerValue];
        _reviewCount = [attributes[@"review_count"] integerValue];
        _distance = [attributes[@"distance"] integerValue];
        _businessURL = attributes[@"business_url"];
        _photoURL = attributes[@"photo_url"];
        _smallPhotoURL = attributes[@"s_photo_url"];
        _hasCoupon = [attributes[@"has_coupon"] integerValue];
        _couponID = [attributes[@"coupon_id"] integerValue];
        _couponDesc = attributes[@"coupon_description"];
        _couponURL = attributes[@"coupon_url"];
        _hasDeal = [attributes[@"has_deal"] integerValue];
        _dealCount = [attributes[@"deal_count"] integerValue];
        
        NSMutableArray *deals = [NSMutableArray array];
        for (NSDictionary *dealAttributes in attributes[@"deals"]) {
            DPDeal *deal = [[DPDeal alloc] init];
            deal.dealID = dealAttributes[@"id"];
            deal.desc = dealAttributes[@"description"];
            deal.dealURL = dealAttributes[@"h5_url"];
            [deals addObject:deal];
        }
        _deals = deals;
    }
    
    return self;
}

+ (NSURLSessionDataTask *)businessesWithParams:(NSDictionary *)params
                                         block:(void (^)(NSArray *, NSError *))block
{
    return [[DPAPI sharedAPI] GET:@"business/find_businesses"
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
                            
                            NSArray *businessesFromResponse = JSON[@"businesses"];
                            NSMutableArray *businesses = [NSMutableArray array];
                            
                            for (NSDictionary *attributes in businessesFromResponse) {
                                DPBusiness *business = [[DPBusiness alloc] initWithAttributes:attributes];
                                [businesses addObject:business];
                            }
                            
                            if (block) {
                                block(businesses, nil);
                            }
                        }
                        failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                            if (block) {
                                block(nil, error);
                            }
                        }
            ];
}

+ (NSURLSessionDataTask *)businessWithID:(NSInteger)businessID
                                  params:(NSDictionary *)params
                                   block:(void (^)(DPBusiness *, NSError *))block
{
    NSMutableDictionary *mutableParams = params ? [params mutableCopy] : [NSMutableDictionary dictionary];
    [mutableParams setObject:businessID ? @(businessID) : @0 forKey:@"business_id"];
    
    return [[DPAPI sharedAPI] GET:@"business/get_single_business"
                       parameters:[DPAPI signedParamsWithParmas:mutableParams]
                          success:^(NSURLSessionDataTask * __unused task, id JSON) {
                              int errorCode = [JSON[@"error"][@"errorCode"] intValue];
                              if (errorCode) {
                                  NSLog(@"Error: %@", JSON[@"error"][@"errorMessage"]);
                                  
                                  if (block) {
                                      block(nil, [DPAPI errorWithCode:errorCode message:JSON[@"error"][@"errorMessage"]]);
                                  }
                                  
                                  return;
                              }
                              
                              NSArray *businessesFromResponse = JSON[@"businesses"];
                              DPBusiness *business;
                              
                              for (NSDictionary *attributes in businessesFromResponse) {
                                  business = [[DPBusiness alloc] initWithAttributes:attributes];
                                  break;
                              }
                              
                              if (block) {
                                  block(business, nil);
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
