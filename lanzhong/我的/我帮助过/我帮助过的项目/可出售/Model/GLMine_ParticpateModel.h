//
//  GLMine_ParticpateModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_ParticpateModel : NSObject

@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *info;//描述
@property (nonatomic, copy)NSString *state;//  项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败  6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成 11项目结束'
@property (nonatomic, copy)NSString *sev_photo;//图片
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *time;//出售时间，没有出售就不管
@property (nonatomic, copy)NSString *user_count;//参与人数
@property (nonatomic, copy)NSString *is_sale;//是否是购买来的 1是 0否
@property (nonatomic, copy)NSString *ensure_type; //1无保障计划  2项目发布人自保  3项目出保
@property (nonatomic, copy)NSString *s_time;//项目开始时间
@property (nonatomic, copy)NSString *need_time;//项目结束时间
@property (nonatomic, copy)NSString *invest_id;//项目权益id
@property (nonatomic, copy)NSString *attorn_phone;//转让人电话

@property (nonatomic, copy)NSString *admin_money;//完成的资金

@property (nonatomic, copy)NSString *attorn_money1;//买入价格 (可出售)
@property (nonatomic, copy)NSString *invest_money1;//项目投资金额(可出售)

@property (nonatomic, copy)NSString *attorn_money;//转让金额
@property (nonatomic, copy)NSString *attorn_money2;//买入金额
@property (nonatomic, copy)NSString *invest_money2;//项目投入资金

@property (nonatomic, copy)NSString *type;//类型:0可出售 1不可出售 2出售中


@end
