//
//  GLBusiness_DetailForSaleModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/11.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBusiness_DetailForSaleModel : NSObject

@property (nonatomic, copy)NSString *attorn_id;//转让id
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *invest_id;//支持Id
@property (nonatomic, copy)NSString *uid;//转让人uid
@property (nonatomic, copy)NSString *is_attorn;//否转让成功  1完成转让 3 转让中
@property (nonatomic, copy)NSString *addtime;//转让发布时间
@property (nonatomic, copy)NSString *attorn_phone;//转让人电话

@property (nonatomic, copy)NSString *attorn_money;//转让金额
@property (nonatomic, copy)NSString *sev_photo;//项目展示图
@property (nonatomic, copy)NSString *title;//项目名
@property (nonatomic, copy)NSString *linkman;//项目联系人
@property (nonatomic, copy)NSString *admin_money;//后台评估金额
@property (nonatomic, copy)NSString *ensure_type;// 百万保障类型 1无保障计划  2项目发布人自保  3项目出保
@property (nonatomic, copy)NSString *info;//项目简介描述
@property (nonatomic, copy)NSString *promise_word;//承诺书
@property (nonatomic, copy)NSString *money_use_word;//资金使用计划书
@property (nonatomic, copy)NSString *rights_word;//项目权益分配计划书
@property (nonatomic, copy)NSString *nickname;//转让发布人昵称
@property (nonatomic, copy)NSString *uname;//转让发布人用户名
@property (nonatomic, copy)NSString *money;//支持金额
@property (nonatomic, copy)NSString *item_get_time;//最后盈利时间
@property (nonatomic, copy)NSString *item_get_money;//个人盈利所得
@property (nonatomic, copy)NSString *item_get_money_sum;//最近盈利所得

@end
