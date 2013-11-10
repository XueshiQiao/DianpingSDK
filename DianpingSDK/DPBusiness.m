//
//  DPBusiness.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPBusiness.h"
#import "DPAPI.h"

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
        self.ratingImgURLSmall = attributes[@"rating_s_img_url"];
        self.productGrade = [attributes[@"product_grade"] integerValue];
        self.decorationGrade = [attributes[@"decoration_grade"] integerValue];
        self.serviceGrade = [attributes[@"service_grade"] integerValue];
        self.avgPrice = [attributes[@"avg_price"] integerValue];
        self.reviewCount = [attributes[@"review_count"] integerValue];
        self.distance = [attributes[@"distance"] integerValue];
        self.businessURL = attributes[@"business_url"];
        self.photoURL = attributes[@"photo_url"];
        self.photoURLSmall = attributes[@"s_photo_url"];
        self.hasCoupon = [attributes[@"has_coupon"] integerValue];
        self.couponID = [attributes[@"coupon_id"] integerValue];
        self.couponDescription = attributes[@"coupon_description"];
        self.couponURL = attributes[@"coupon_url"];
        self.hasDeal = [attributes[@"has_deal"] integerValue];
        self.dealCount = [attributes[@"deal_count"] integerValue];
        self.deals = attributes[@"deals"];
    }
    
    return self;
}

+ (NSURLSessionDataTask *)businessesWithParams:(NSDictionary *)params block:(void (^)(NSArray *, NSError *))block
{
    return [[DPAPI sharedAPI] GET:@"business/find_businesses"
                     parameters:params
                        success:^(NSURLSessionDataTask * __unused task, id JSON) {
                            NSLog(@"json:%@", JSON);
                            int errorCode = [JSON[@"error"][@"errorCode"] intValue];
                            if (errorCode) {
                                NSLog(@"Error: %@", JSON[@"error"][@"errorMessage"]);
                                
                                if (block) {
                                    block([NSArray arrayWithArray:nil], [DPAPI errorWithCode:errorCode message:JSON[@"error"][@"errorMessage"]]);
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
                                block([NSArray array], error);
                            }
                        }
            ];
}
@end
