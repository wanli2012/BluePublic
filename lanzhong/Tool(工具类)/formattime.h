//
//  formattime.h
//  幼儿园平台
//
//  Created by admin on 16/1/20.
//  Copyright (c) 2016年 ZhiYiChuangXin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface formattime : NSObject

+ (NSString *)formateTime:(NSString *)time;//YYYY-MM-dd

+ (NSString *)formateTimeYM:(NSString *)time;//YYYY年MM月

+ (NSString *)formateTimeOfDate:(NSString *)time;//MM-dd

+ (NSString *)formateTimeOfDate2:(NSString *)time;//dd/MM月

+ (NSString *)formateTimeOfDate3:(NSString *)time;//YYYY.MM.dd

+ (NSString *)formateTimeOfDate4:(NSString *)time;//YYYY.MM.dd  不显示时分秒

@end
