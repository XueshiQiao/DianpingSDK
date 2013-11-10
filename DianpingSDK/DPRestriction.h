//
//  DPRestriction.h
//  DianpingSDKDemo
//
//  Created by Johnny on 11/10/13.
//  Copyright (c) 2013 Johnny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPRestriction : NSObject

@property (nonatomic, assign) NSInteger isReservationRequired;          // 是否需要预约，0：不是，1：是
@property (nonatomic, assign) NSInteger isRefundable;                   // 是否支持随时退款，0：不是，1：是
@property (nonatomic, strong) NSString *specialTips;                    // 附加信息(一般为团购信息的特别提示)

@end
