//
//  DPBusiness.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPBusiness : NSObject

@property (nonatomic, assign) NSInteger businessID;         // 商户ID
@property (nonatomic, strong) NSString *name;               // 商户名
@property (nonatomic, strong) NSString *branchName;         // 分店名
@property (nonatomic, strong) NSString *address;            // 地址
@property (nonatomic, strong) NSString *telephone;          // 带区号的电话
@property (nonatomic, strong) NSString *city;               // 所在城市
@property (nonatomic, strong) NSArray *regions;             // 所在区域信息列表，如[徐汇区，徐家汇]
@property (nonatomic, strong) NSArray *categories;          // 所属分类信息列表，如[宁波菜，婚宴酒店]
@property (nonatomic, assign) CGFloat latitude;             // 纬度坐标
@property (nonatomic, assign) CGFloat longitude;            // 经度坐标
@property (nonatomic, assign) CGFloat avgRating;            // 星级评分，5.0代表五星，4.5代表四星半，依此类推
@property (nonatomic, strong) NSString *ratingImgURL;       // 星级图片链接
@property (nonatomic, strong) NSString *smallRatingImgURL;  // 小尺寸星级图片链接
@property (nonatomic, assign) NSInteger productGrade;       // 产品/食品口味评价，1:一般，2:尚可，3:好，4:很好，5:非常好
@property (nonatomic, assign) NSInteger decorationGrade;    // 环境评价，1:一般，2:尚可，3:好，4:很好，5:非常好
@property (nonatomic, assign) NSInteger serviceGrade;       // 服务评价，1:一般，2:尚可，3:好，4:很好，5:非常好
@property (nonatomic, assign) NSInteger avgPrice;           // 人均价格，单位:元，若没有人均，返回-1
@property (nonatomic, assign) NSInteger reviewCount;        // 点评数量
@property (nonatomic, assign) NSInteger distance;           // 商户与参数坐标的距离，单位为米，如不传入经纬度坐标，结果为-1
@property (nonatomic, strong) NSString *businessURL;        // 商户页面链接
@property (nonatomic, strong) NSString *photoURL;           // 照片链接，照片最大尺寸700×700
@property (nonatomic, strong) NSString *smallPhotoURL;      // 小尺寸照片链接，照片最大尺寸278×200
@property (nonatomic, assign) NSInteger hasCoupon;          // 是否有优惠券，0:没有，1:有
@property (nonatomic, assign) NSInteger couponID;           // 优惠券ID
@property (nonatomic, strong) NSString *couponDesc;         // 优惠券描述
@property (nonatomic, strong) NSString *couponURL;          // 优惠券页面链接
@property (nonatomic, assign) NSInteger hasDeal;            // 是否有团购，0:没有，1:有
@property (nonatomic, assign) NSInteger dealCount;          // 商户当前在线团购数量
@property (nonatomic, strong) NSArray *deals;               // 团购列表


// 获取符合指定条件的商户列表
// 可用参数列表：http://developer.dianping.com/app/api/v1/business/find_businesses
+ (NSURLSessionDataTask *)businessesWithParams:(NSDictionary *)params
                                         block:(void (^)(NSArray *businesses, NSError *error))block;

// 获取特定商户的详细信息
// 可用参数列表：http://developer.dianping.com/app/api/v1/business/get_single_business
+ (NSURLSessionDataTask *)businessWithID:(NSInteger)businessID
                                  params:(NSDictionary *)params
                                   block:(void (^)(DPBusiness *business, NSError *error))block;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
