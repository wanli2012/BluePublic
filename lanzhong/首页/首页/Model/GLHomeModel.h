//
//  GLHomeModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLHome_groom_itemModel : NSObject

@property (nonatomic, copy)NSString *uid;//发布人
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *sev_photo;// 展示图
@property (nonatomic, copy)NSString *title;// 标题
@property (nonatomic, copy)NSString *time;//发布时间
@property (nonatomic, copy)NSString *classify;//完成金额
@property (nonatomic, copy)NSString *draw_money;//后台评估金额
@property (nonatomic, copy)NSString *admin_money;//1:爱心项目 2:创客项目
@property (nonatomic, copy)NSString *stop;//项目运行状态  1正常 2禁止 3完成
@property (nonatomic, copy)NSString *invest_count;//人数
@property (nonatomic, copy)NSString *issue;//发布方

@end

@interface GLHome_newNoticeModel : NSObject

@property (nonatomic, copy)NSString *news_id;//公告id
@property (nonatomic, copy)NSString *title;//公告title

@end

@interface GLHomeModel : NSObject

@property (nonatomic, copy)NSString *ai_item_num;//爱心项目数量
@property (nonatomic, copy)NSString *ai_over_num;// 完成金额
@property (nonatomic, copy)NSString *ai_man_num;//参与人数
@property (nonatomic, copy)NSString *c_item_num;//创客项目数量
@property (nonatomic, copy)NSString *c_over_num;//完成金额
@property (nonatomic, copy)NSString *c_man_num;//参与人数
@property (nonatomic, strong, getter = theNew_notice)GLHome_newNoticeModel *new_notice;//公告
@property (nonatomic, copy)NSArray <GLHome_groom_itemModel *>*groom_item;

@end
