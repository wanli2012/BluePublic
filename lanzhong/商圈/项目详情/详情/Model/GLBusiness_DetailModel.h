//
//  GLBusiness_DetailModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBusiness_HeartModel : NSObject

@property (nonatomic, copy)NSString *id;//项目id
@property (nonatomic, copy)NSString *uid;//项目id
@property (nonatomic, copy)NSString *money;//项目id
@property (nonatomic, copy)NSString *addtime;//项目id
@property (nonatomic, copy)NSString *uname;//项目id
@property (nonatomic, copy)NSString *must_user_pic;//项目id
@property (nonatomic, copy)NSString *nickname;//项目id

@end

@interface GLBusiness_CommentModel : NSObject

@property (nonatomic, copy)NSString *id;//评论id
@property (nonatomic, copy)NSString *uid;//项目id
@property (nonatomic, copy)NSString *money;//支持金额
@property (nonatomic, copy)NSString *addtime;//支持时间
@property (nonatomic, copy)NSString *comment;//评论内容
@property (nonatomic, copy)NSString *c_time;//评论时间
@property (nonatomic, copy)NSString *reply;//回复内容
@property (nonatomic, copy)NSString *reply_time;//回复时间
@property (nonatomic, copy)NSString *uname;//用户名
@property (nonatomic, copy)NSString *must_user_pic;//头像
@property (nonatomic, copy)NSString *nickname;//昵称
@property (nonatomic, copy)NSString *linkman;//

@property (nonatomic, assign)CGFloat cellHeight;
@property (nonatomic, assign)NSInteger signIndex;//1:可以回复  0:不能回复,只能看


@end

@interface GLBusiness_DetailModel : NSObject
@property (nonatomic, copy)NSString *ensure_type;//保障类型
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *uid;//用户id
@property (nonatomic, copy)NSString *trade_id;//行业id
@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *details;//项目内容
@property (nonatomic, copy)NSString *linkman;//联系人名字
@property (nonatomic, copy)NSString *state;// 项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败  6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
@property (nonatomic, copy)NSString *groom;//是否推荐该项目   1是  0否
@property (nonatomic, copy)NSString *draw_money;//项目完成资金
@property (nonatomic, copy)NSString *budget_money;//项目预算资金
@property (nonatomic, copy)NSString *admin_money;//后台评估资金
@property (nonatomic, copy)NSString *is_del;//后台操作标记   APP不用管
@property (nonatomic, copy)NSString *user_del;//用户是否删除  0否 1是
@property (nonatomic, copy)NSString *info;//项目描述
@property (nonatomic, copy)NSString *time;//项目发布时间
@property (nonatomic, copy)NSString *addtime;//项目申请时间
@property (nonatomic, copy)NSString *phone;//项目联系电话
@property (nonatomic, copy)NSString *photo;//后台使用图片路径  不用管
@property (nonatomic, copy)NSString *classify;//项目类型   1:爱心项目  2:创客项目
@property (nonatomic, copy)NSArray *sev_photo;//项目展示图片 APP使用
@property (nonatomic, copy)NSString *need_time;//项目截止时间

@property (nonatomic, copy)NSString *user_info_pic;//头像
@property (nonatomic, copy)NSString *invest_count;//榜单人数
@property (nonatomic, copy)NSString *promise_word;//承诺书
@property (nonatomic, copy)NSString *money_use_word;//资金使用计划书
@property (nonatomic, copy)NSString *rights_word;//项目权益分配计划书

@property (nonatomic, copy)NSArray <GLBusiness_HeartModel *>*invest_10;//爱心排行榜
@property (nonatomic, copy)NSArray <GLBusiness_CommentModel *>*invest_list;//支持评论列表

@end
