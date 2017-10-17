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
@property (nonatomic, copy)NSString *state;// 项目审核发布状态 0审核中  1通过  2失败
@property (nonatomic, copy)NSString *sev_photo;//图片
@property (nonatomic, copy)NSString *i_money;//我支持的金额

@property (nonatomic, copy)NSString *id;//支持id
@property (nonatomic, copy)NSString *uid;// uid
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *addtime;// 支持时间
@property (nonatomic, copy)NSString *comment;// 评论
@property (nonatomic, copy)NSString *c_time;//评论时间
@property (nonatomic, copy)NSString *reply;// 回复
@property (nonatomic, copy)NSString *reply_time;//回复时间
@property (nonatomic, copy)NSString *classify;// 项目类型  1:爱心项目  2:创客项目
@property (nonatomic, copy)NSString *admin_money;//后台评估金额
@property (nonatomic, copy)NSString *draw_money;// 已完成金额


@end
