//
//  GLBusinessCircleModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCircle_itemScreen_manModel : NSObject

@property (nonatomic, copy)NSString *trade_id;
@property (nonatomic, copy)NSString *trade_name;

@end

@interface GLCircle_item_screenModel : NSObject

@property (nonatomic, strong)NSArray <GLCircle_itemScreen_manModel *>* man;
@property (nonatomic, strong)NSArray <GLCircle_itemScreen_manModel *>* stop;
@property (nonatomic, strong)NSArray <GLCircle_itemScreen_manModel *>* trade;

@end

@interface GLCircle_item_dataModel : NSObject

@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *state;//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败  6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
@property (nonatomic, copy)NSString *sev_photo;//展示图片
@property (nonatomic, copy)NSString *uid;//发布人
@property (nonatomic, copy)NSString *draw_money;//已完成金额
@property (nonatomic, copy)NSString *admin_money;// 后台估算金额
@property (nonatomic, copy)NSString *time;//发布时间
@property (nonatomic, copy)NSString *invest_count;//参与人数
@property (nonatomic, copy)NSString *issue;//发布方

@property (nonatomic, copy)NSString *attorn_id;//转让id
@property (nonatomic, copy)NSString *invest_id;//项目权益id
@property (nonatomic, copy)NSString *addtime;//转让发布时间
@property (nonatomic, copy)NSString *attorn_phone;//转让人电话
@property (nonatomic, copy)NSString *info;//项目简介
@property (nonatomic, copy)NSString *nickname;//发布人昵称
@property (nonatomic, copy)NSString *ensure_type;//百万保障类型 1无保障计划 2项目发布人自保 3项目出保
@property (nonatomic, copy)NSString *uname;//发布人用户名
@property (nonatomic, copy)NSString *attorn_money;//预估价

@end

@interface GLBusinessCircleModel : NSObject

@property (nonatomic, strong)GLCircle_item_screenModel *item_screen;

@property (nonatomic, strong)NSArray <GLCircle_item_dataModel *>* item_data;

@end
