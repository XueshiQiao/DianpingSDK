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
        _dealID = attributes[@"deal_id"];
        _title = attributes[@"title"];
        _desc = attributes[@"description"];
        _city = attributes[@"city"];
        _listPrice = [attributes[@"list_price"] floatValue];
        _currentPrict = [attributes[@"current_price"] floatValue];
        _regions = attributes[@"regions"];
        _categories = attributes[@"categories"];
        _purchaseCount = [attributes[@"purchase_count"] integerValue];
        _publishDate = attributes[@"publish_date"];
        _details = attributes[@"details"];
        _purchaseDeadline = attributes[@"purchase_deadline"];
        _imageURL = attributes[@"image_url"];
        _smallImageURL = attributes[@"s_image_url"];
        _moreImageURLs = attributes[@"more_image_urls"];
        _moreSmallImageURLs = attributes[@"more_s_image_urls"];
        _isPopular = [attributes[@"is_popular"] integerValue];
        
        NSMutableArray *restrictions = [NSMutableArray array];
        for (NSDictionary *restrictionAttributes in attributes[@"restrictions"]) {
            DPRestriction *restriction = [[DPRestriction alloc] init];
            restriction.isReservationRequired = [restrictionAttributes[@"is_reservation_required"] integerValue];
            restriction.isRefundable = [restrictionAttributes[@"is_refundable"] integerValue];
            restriction.specialTips = restrictionAttributes[@"special_tips"];
            [restrictions addObject:restriction];
        }
        _restrictions = restrictions;
        
        _notice = attributes[@"notice"];
        _dealURL = attributes[@"deal_h5_url"];
        
        NSMutableArray *businesses = [NSMutableArray array];
        for (NSDictionary *businessAttributes in attributes[@"businesses"]) {
            DPBusiness *business = [[DPBusiness alloc] init];
            business.businessID = [businessAttributes[@"id"] integerValue];
            business.name = businessAttributes[@"name"];
            business.address = businessAttributes[@"address"];
            business.latitude = [businessAttributes[@"latitude"] floatValue];
            business.longitude = [businessAttributes[@"longitude"] floatValue];
            business.businessURL = businessAttributes[@"h5_url"];
            [businesses addObject:business];
        }
        _businesses = businesses;
    }
    
    return self;
}

+ (NSURLSessionDataTask *)dealWithID:(NSString *)dealID
                               block:(void (^)(DPDeal *, NSError *))block
{
    NSDictionary *params = @{@"deal_id" : dealID ? dealID : @""};
    
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
                              
                              NSArray *dealsFromResponse = JSON[@"deals"];
                              DPDeal *deal;
                              
                              for (NSDictionary *attributes in dealsFromResponse) {
                                  deal = [[DPDeal alloc] initWithAttributes:attributes];
                                  break;
                              }
                              
                              if (block) {
                                  block(deal, nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

+ (NSURLSessionDataTask *)dealsWithIDs:(NSArray *)dealIDs
                                 block:(void (^)(NSArray *, NSError *))block
{
    NSMutableString *paramString= [NSMutableString string];
    for (NSString *dealID in dealIDs) {
        if (paramString.length > 0) {
            [paramString appendString:@","];
        }
        
        [paramString appendString:dealID];
    }
    
    NSDictionary *params = @{@"deal_ids" : paramString ? paramString : @""};
    
    return [[DPAPI sharedAPI] GET:@"deal/get_batch_deals_by_id"
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
                              
                              NSArray *dealsFromResponse = JSON[@"deals"];
                              NSMutableArray *deals = [NSMutableArray array];
                              
                              for (NSDictionary *attributes in dealsFromResponse) {
                                  DPDeal *deal = [[DPDeal alloc] initWithAttributes:attributes];
                                  [deals addObject:deal];
                              }
                              
                              if (block) {
                                  block(deals, nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

+ (NSURLSessionDataTask *)dealIDsWithCity:(NSString *)city
                                     date:(NSString *)date
                                 category:(NSString *)category
                                    block:(void (^)(NSArray *, NSError *))block
{
    NSString *URLString = @"deal/get_all_id_list";
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionary];
    [mutableParams setObject:city ? city : @"" forKey:@"city"];
    
    if (category) {
        [mutableParams setObject:category ? category : @"" forKey:@"category"];
    }
    
    // 获取指定日期的团购
    if (date.length == 10) {
        URLString = @"deal/get_daily_new_id_list";
        [mutableParams setObject:date forKey:@"date"];
    }
    
    return [[DPAPI sharedAPI] GET:URLString
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
                              
                              if (block) {
                                  block(JSON[@"id_list"], nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

+ (NSURLSessionDataTask *)dealsWithCity:(NSString *)city
                             businessID:(NSInteger)businessID
                                  block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary *params = @{@"city" : city ? city : @"",
                             @"business_id" : businessID ? @(businessID) : @0};
    
    return [[DPAPI sharedAPI] GET:@"deal/get_deals_by_business_id"
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
                              
                              NSArray *dealsFromResponse = JSON[@"deals"];
                              NSMutableArray *deals = [NSMutableArray array];
                              
                              for (NSDictionary *attributes in dealsFromResponse) {
                                  DPDeal *deal = [[DPDeal alloc] initWithAttributes:attributes];
                                  [deals addObject:deal];
                              }
                              
                              if (block) {
                                  block(deals, nil);
                              }
                          }
                          failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
                              if (block) {
                                  block(nil, error);
                              }
                          }
            ];
}

+ (NSURLSessionDataTask *)dealsWithCity:(NSString *)city
                                 params:(NSDictionary *)params
                                  block:(void (^)(NSArray *, NSError *))block
{
    NSMutableDictionary *mutableParams = params ? [params mutableCopy] : [NSMutableDictionary dictionary];
    [mutableParams setObject:city ? city : @"" forKey:@"city"];
    
    return [[DPAPI sharedAPI] GET:@"deal/find_deals"
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
                              
                              NSArray *dealsFromResponse = JSON[@"deals"];
                              NSMutableArray *deals = [NSMutableArray array];
                              
                              for (NSDictionary *attributes in dealsFromResponse) {
                                  DPDeal *deal = [[DPDeal alloc] initWithAttributes:attributes];
                                  [deals addObject:deal];
                              }
                              
                              if (block) {
                                  block(deals, nil);
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
