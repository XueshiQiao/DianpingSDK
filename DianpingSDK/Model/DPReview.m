//
//  DPReview.m
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import "DPReview.h"
#import "DPAPI.h"

@implementation DPReview

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    if (self = [super init]) {
        _reviewID = [attributes[@"review_id"] integerValue];
        _userNickname = attributes[@"user_nickname"];
        _createdTime = attributes[@"created_time"];
        _textExcerpt = attributes[@"text_excerpt"];
        _reviewRating = [attributes[@"review_rating"] floatValue];
        _ratingImgURL = attributes[@"rating_img_url"];
        _smallRatingImgURL = attributes[@"rating_s_img_url"];
        _productRating = [attributes[@"product_rating"] integerValue];
        _decorationRating = [attributes[@"decoration_rating"] integerValue];
        _serviceRating = [attributes[@"service_rating"] integerValue];
        _reviewURL = attributes[@"review_url"];
    }
    
    return self;
}

+ (NSURLSessionDataTask *)reviewsWithBusinessID:(NSInteger)businessID
                                          block:(void (^)(NSArray *, NSError *))block
{
    NSDictionary *params = @{@"business_id" : businessID ? @(businessID) : @0,
                             @"platform" : @2};
    
    return [[DPAPI sharedAPI] GET:@"review/get_recent_reviews"
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
                              
                              NSArray *reviewsFromResponse = JSON[@"reviews"];
                              NSMutableArray *reviews = [NSMutableArray array];
                              
                              for (NSDictionary *attributes in reviewsFromResponse) {
                                  DPReview *review = [[DPReview alloc] initWithAttributes:attributes];
                                  [reviews addObject:review];
                              }
                              
                              if (block) {
                                  block(reviews, nil);
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
