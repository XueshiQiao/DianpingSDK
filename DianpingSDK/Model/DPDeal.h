//
//  DPDeal.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPDeal : NSObject

@property (nonatomic, strong) NSString *dealID;                 // 团购单ID
@property (nonatomic, strong) NSString *title;                  // 团购标题
@property (nonatomic, strong) NSString *desc;                   // 团购描述
@property (nonatomic, strong) NSString *city;                   // 城市名称，city为＂全国＂表示全国单，其他为本地单
@property (nonatomic, assign) CGFloat listPrice;                // 团购包含商品原价值
@property (nonatomic, assign) CGFloat currentPrict;             // 团购价格
@property (nonatomic, strong) NSArray *regions;                 // 团购适用商户所在商区
@property (nonatomic, strong) NSArray *categories;              // 团购所属分类
@property (nonatomic, assign) NSInteger purchaseCount;          // 团购当前已购买数
@property (nonatomic, strong) NSString *publishDate;            // 团购发布上线日期
@property (nonatomic, strong) NSString *details;                // 团购详情
@property (nonatomic, strong) NSString *purchaseDeadline;       // 团购单的截止购买日期
@property (nonatomic, strong) NSString *imageURL;               // 团购图片链接，最大图片尺寸450×280
@property (nonatomic, strong) NSString *smallImageURL;          // 小尺寸团购图片链接，最大图片尺寸160×100
@property (nonatomic, strong) NSArray *moreImageURLs;           // 更多大尺寸图片
@property (nonatomic, strong) NSArray *moreSmallImageURLs;      // 更多小尺寸图片
@property (nonatomic, assign) NSInteger isPopular;              // 是否为热门团购，0：不是，1：是
@property (nonatomic, strong) NSArray *restrictions;            // 团购限制条件
@property (nonatomic, strong) NSString *notice;                 // 重要通知(一般为团购信息的临时变更)
@property (nonatomic, strong) NSString *dealURL;                // 团购HTML5 Web页面链接
@property (nonatomic, strong) NSArray *businesses;              // 团购所适用的商户列表


// 获取特定的团购信息
+ (NSURLSessionDataTask *)dealWithID:(NSString *)dealID
                               block:(void (^)(DPDeal *deal, NSError *error))block;

// 批量获取团购信息
+ (NSURLSessionDataTask *)dealsWithIDs:(NSArray *)dealIDs
                                 block:(void (^)(NSArray *deals, NSError *error))block;

// 获取特定城市特定分类（和日期）的团购ID
+ (NSURLSessionDataTask *)dealIDsWithCity:(NSString *)city
                                     date:(NSString *)date
                                 category:(NSString *)category
                                    block:(void (^)(NSArray *dealIDs, NSError *error))block;

// 获取特定城市特定商户的团购信息
+ (NSURLSessionDataTask *)dealsWithCity:(NSString *)city
                             businessID:(NSInteger)businessID
                                  block:(void (^)(NSArray *deals, NSError *error))block;

// 获取特定城市符合指定条件的团购列表
// 可用参数列表：http://developer.dianping.com/app/api/v1/deal/find_deals
+ (NSURLSessionDataTask *)dealsWithCity:(NSString *)city
                                 params:(NSDictionary *)params
                                  block:(void (^)(NSArray *deals, NSError *error))block;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
