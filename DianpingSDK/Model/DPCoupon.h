//
//  DPCoupon.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPCoupon : NSObject

@property (nonatomic, assign) NSInteger couponID;               // 优惠券ID
@property (nonatomic, strong) NSString *title;                  // 优惠券标题
@property (nonatomic, strong) NSString *desc;                   // 优惠券描述
@property (nonatomic, strong) NSArray *regions;                 // 优惠券适用商户所在行政区
@property (nonatomic, strong) NSArray *categories;              // 优惠券所属分类
@property (nonatomic, assign) NSInteger downloadCount;          // 优惠券当前已下载量
@property (nonatomic, strong) NSString *publishDate;            // 优惠券发布上线日期
@property (nonatomic, strong) NSString *expirationDate;         // 优惠券的截止使用日期

// 优惠券所适用商户中距离参数坐标点最近的一家与坐标点的距离，单位为米；如不传入经纬度坐标，结果为-1；如优惠券无关联商户，结果为MAXINT
@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, strong) NSString *logoImgURL;             // 优惠券的图标，尺寸120＊90
@property (nonatomic, strong) NSString *couponURL;              // 优惠券HTML5 Web页面链接
@property (nonatomic, strong) NSArray *businesses;              // 优惠券所适用的商户列表


// 获取符合指定条件的优惠券列表
// 可用参数列表：http://developer.dianping.com/app/api/v1/coupon/find_coupons
+ (NSURLSessionDataTask *)couponsWithParams:(NSDictionary *)params
                                      block:(void (^)(NSArray *coupons, NSError *error))block;

// 获取特定的优惠券
// 可用参数列表：http://developer.dianping.com/app/api/v1/coupon/get_single_coupon
+ (NSURLSessionDataTask *)couponWithID:(NSInteger)couponID
                                 block:(void (^)(DPCoupon *coupon, NSError *error))block;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
