//
//  GLMine_AddressModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/13.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_AddressModel : NSObject

@property (nonatomic, copy)NSString *address_id;//收货地址id
@property (nonatomic, copy)NSString *collect_name;//收货人姓名

@property (nonatomic, copy)NSString *province;//省级地区
@property (nonatomic, copy)NSString *city;//市级地区
@property (nonatomic, copy)NSString *area;//区县

@property (nonatomic, copy)NSString *province_name;//省名
@property (nonatomic, copy)NSString *city_name;//市名
@property (nonatomic, copy)NSString *area_name;//区名

@property (nonatomic, copy)NSString *address;//详细地址
@property (nonatomic, copy)NSString *uid;//用户id
@property (nonatomic, copy)NSString *phone;//收货电话
@property (nonatomic, copy)NSString *is_default;//是否是默认收货地址
@property (nonatomic, copy)NSString *del;//0:使用中 1:已删除'
@property (nonatomic, copy)NSString *addtime;//添加时间


@end
