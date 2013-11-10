//
//  DPDeal.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPDeal.h"
#import "DPAPI.h"
#import "DPBusiness.h"
#import "DPRestriction.h"

@implementation DPDeal

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    if (self == [super init]) {
        self.dealID = attributes[@"deal_id"];
        self.title = attributes[@"title"];
        self.desc = attributes[@"description"];
        self.city = attributes[@"city"];
        self.listPrice = [attributes[@"list_price"] floatValue];
        self.currentPrict = [attributes[@"current_price"] floatValue];
        self.regions = attributes[@"regions"];
        self.categories = attributes[@"categories"];
        self.purchaseCount = [attributes[@"purchase_count"] integerValue];
        self.publishDate = attributes[@"publish_date"];
        self.details = attributes[@"details"];
        self.purchaseDeadline = attributes[@"purchase_deadline"];
        self.imageURL = attributes[@"image_url"];
        self.smallImageURL = attributes[@"s_image_url"];
        self.moreImageURLs = attributes[@"more_image_urls"];
        self.moreSmallImageURLs = attributes[@"more_s_image_urls"];
        self.isPopular = [attributes[@"is_popular"] integerValue];
        
        NSMutableArray *restrictions = [NSMutableArray array];
        for (NSDictionary *restrictionAttributes in attributes[@"restrictions"]) {
            DPRestriction *restriction = [[DPRestriction alloc] init];
            restriction.isReservationRequired = [restrictionAttributes[@"is_reservation_required"] integerValue];
            restriction.isRefundable = [restrictionAttributes[@"is_refundable"] integerValue];
            restriction.specialTips = restrictionAttributes[@"special_tips"];
            [restrictions addObject:restriction];
        }
        self.restrictions = restrictions;
        
        self.notice = attributes[@"notice"];
        self.dealURL = attributes[@"deal_url"];
        self.dealHTML5URL = attributes[@"deal_h5_url"];
        
        NSMutableArray *businesses = [NSMutableArray array];
        for (NSDictionary *businessAttributes in attributes[@"businesses"]) {
            DPBusiness *business = [[DPBusiness alloc] init];
            business.businessID = [businessAttributes[@"id"] integerValue];
            business.name = businessAttributes[@"name"];
            business.address = businessAttributes[@"address"];
            business.latitude = [businessAttributes[@"latitude"] floatValue];
            business.longitude = [businessAttributes[@"longitude"] floatValue];
            business.businessURL = businessAttributes[@"url"];
            [businesses addObject:business];
        }
        self.businesses = businesses;
    }
    
    return self;
}

+ (NSURLSessionDataTask *)dealsWithParams:(NSDictionary *)params
                                    block:(void (^)(NSArray *, NSError *))block
{
    return [[DPAPI sharedAPI] GET:@"deal/get_single_deal"
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
                              
                              NSArray *postsFromResponse = [JSON valueForKeyPath:@"deals"];
                              NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                              
                              for (NSDictionary *attributes in postsFromResponse) {
                                  DPDeal *deal = [[DPDeal alloc] initWithAttributes:attributes];
                                  [mutablePosts addObject:deal];
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

@end
