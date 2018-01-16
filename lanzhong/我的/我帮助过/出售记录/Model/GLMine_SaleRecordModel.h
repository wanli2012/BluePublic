//
//  GLMine_SaleRecordModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_SaleRecordModel : NSObject

@property (nonatomic, copy)NSString *title; //项目标题
@property (nonatomic, copy)NSString *name;//真实名字或者用户名
@property (nonatomic, copy)NSString *time;//交易成功时间
@property (nonatomic, copy)NSString *money;//支付金额
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *uid;//uid

@property (nonatomic, assign)NSInteger type;//查询类型 1全部 2出售 3收购

@end
