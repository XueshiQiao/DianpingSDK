//
//  DPReview.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPReview : NSObject

@property (nonatomic, assign) NSInteger reviewID;               // 单条点评ID
@property (nonatomic, strong) NSString *userNickname;           // 该条点评作者的用户名
@property (nonatomic, strong) NSString *createdTime;            // 点评创建时间
@property (nonatomic, strong) NSString *textExcerpt;            // 点评文字片断，前50字
@property (nonatomic, assign) CGFloat reviewRating;             // 点评作者提供的星级评分，5.0代表五星，4.5代表四星半，依此类推
@property (nonatomic, strong) NSString *ratingImgURL;           // 星级图片链接
@property (nonatomic, strong) NSString *smallRatingImgURL;      // 小尺寸星级图片链接
@property (nonatomic, assign) NSInteger productRating;          // 产品/食物口味评价，0:差，1:一般，2:好，3:很好，4:非常好
@property (nonatomic, assign) NSInteger decorationRating;       // 环境评价，0:差，1:一般，2:好，3:很好，4:非常好
@property (nonatomic, assign) NSInteger serviceRating;          // 服务评价，0:差，1:一般，2:好，3:很好，4:非常好
@property (nonatomic, strong) NSString *reviewURL;              // 点评页面链接


// 获取特定商户的最新点评片段
+ (NSURLSessionDataTask *)reviewsWithBusinessID:(NSInteger)businessID
                                          block:(void (^)(NSArray *reviews, NSError *error))block;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
