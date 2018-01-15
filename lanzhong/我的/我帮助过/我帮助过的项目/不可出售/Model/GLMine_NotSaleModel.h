//
//  GLMine_NotSaleModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_NotSaleModel : NSObject

@property (nonatomic, copy)NSString *sev_photo;//项目显示图
@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *info;//项目描述
@property (nonatomic, copy)NSString *admin_money;//完成的资金
@property (nonatomic, copy)NSString *ensure_type;//百万保障类型 1无保障计划  2项目发布人自保  3项目出保
@property (nonatomic, copy)NSString *item_id;//项目于id

@property (nonatomic, copy)NSString *time;//出售时间，没有出售就不管
@property (nonatomic, copy)NSString *is_sale;//是否是购买来的 1是 0否
@property (nonatomic, copy)NSString *s_time;//项目开始时间need_time
@property (nonatomic, copy)NSString *need_time;//项目结束时间

@property (nonatomic, copy)NSString *state;//0:项目筹款中 1:项目筹款失败 2:项目筹款完成 3:项目进行中 4:项目完成 5:项目暂停 6:项目失败 7:项目结束

@end
