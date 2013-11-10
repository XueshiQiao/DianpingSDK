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
        self.businessID = [attributes[@"business_id"] integerValue];
        self.name = attributes[@"name"];
        self.branchName = attributes[@"branch_name"];
        self.address = attributes[@"address"];
        self.telephone = attributes[@"telephone"];
        self.city = attributes[@"city"];
        self.regions = attributes[@"regions"];
        self.categories = attributes[@"categories"];
        self.latitude = [attributes[@"latitude"] floatValue];
        self.longitude = [attributes[@"longitude"] floatValue];
        self.avgRating = [attributes[@"avg_rating"] floatValue];
        self.ratingImgURL = attributes[@"rating_img_url"];
        self.smallRatingImgURL = attributes[@"rating_s_img_url"];
        self.productGrade = [attributes[@"product_grade"] integerValue];
        self.decorationGrade = [attributes[@"decoration_grade"] integerValue];
        self.serviceGrade = [attributes[@"service_grade"] integerValue];
        self.avgPrice = [attributes[@"avg_price"] integerValue];
        self.reviewCount = [attributes[@"review_count"] integerValue];
        self.distance = [attributes[@"distance"] integerValue];
        self.businessURL = attributes[@"business_url"];
        self.photoURL = attributes[@"photo_url"];
        self.smallPhotoURL = attributes[@"s_photo_url"];
        self.hasCoupon = [attributes[@"has_coupon"] integerValue];
        self.couponID = [attributes[@"coupon_id"] integerValue];
        self.couponDesc = attributes[@"coupon_description"];
        self.couponURL = attributes[@"coupon_url"];
        self.hasDeal = [attributes[@"has_deal"] integerValue];
        self.dealCount = [attributes[@"deal_count"] integerValue];
        
        NSMutableArray *deals = [NSMutableArray array];
        for (NSDictionary *dealAttributes in attributes[@"deals"]) {
            DPDeal *deal = [[DPDeal alloc] init];
            deal.dealID = dealAttributes[@"id"];
            deal.desc = dealAttributes[@"description"];
            deal.dealURL = dealAttributes[@"url"];
            [deals addObject:deal];
        }
        self.deals = deals;
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
                            
                            NSArray *postsFromResponse = [JSON valueForKeyPath:@"businesses"];
                            NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                            
                            for (NSDictionary *attributes in postsFromResponse) {
                                DPBusiness *business = [[DPBusiness alloc] initWithAttributes:attributes];
                                [mutablePosts addObject:business];
                            }
                            
                            if (block) {
                                block([NSArray arrayWithArray:mutablePosts], nil);
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
    [mutableParams setObject:[NSString stringWithFormat:@"%d", businessID] forKey:@"business_id"];
    
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
                              
                              NSArray *postsFromResponse = [JSON valueForKeyPath:@"businesses"];
                              DPBusiness *business;
                              for (NSDictionary *attributes in postsFromResponse) {
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
