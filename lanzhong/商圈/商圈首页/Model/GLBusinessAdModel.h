//
//  GLBusinessAdModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBusinessAdModel : NSObject

@property (nonatomic, copy)NSString *banner_id;//广告id
@property (nonatomic, copy)NSString *banner_title;//广告名称
@property (nonatomic, copy)NSString *must_banner;// 广告展示图
@property (nonatomic, copy)NSString *banner_info;//广告描述

@property (nonatomic, copy)NSString *type;//类型1内部广告 2商品广告 3项目广告 4外部链接广告
@property (nonatomic, copy)NSString *url;//外部广告url
@property (nonatomic, copy)NSString *z_id;//商品id或者项目id

@end
