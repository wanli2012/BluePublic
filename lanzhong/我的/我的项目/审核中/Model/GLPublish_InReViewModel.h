//
//  GLPublish_InReViewModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLPublish_InReViewModel : NSObject

@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *classify;//项目类型1:爱心项目 2:创客项目
@property (nonatomic, copy)NSString *state;//项目审核发布状态 0审核中  1通过  2失败
@property (nonatomic, copy)NSString *sev_photo;//项目图片
@property (nonatomic, copy)NSString *draw_money;//已完成金额
@property (nonatomic, copy)NSString *invest_count;//参加项目人数
@property (nonatomic, copy)NSString *info;//详情
@property (nonatomic, copy)NSString *addtime;//申请时间
@property (nonatomic, copy)NSString *need_time;//截止时间
@property (nonatomic, copy)NSString *time;//发布时间

@property (nonatomic, copy)NSString *admin_money;//后台评估金额
@property (nonatomic, copy)NSString *budget_money;//申请金额

@property (nonatomic, assign)BOOL isReviewed;//是否在审核中

@end
