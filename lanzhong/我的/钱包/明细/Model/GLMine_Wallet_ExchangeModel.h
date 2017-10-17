//
//  GLMine_Wallet_ExchangeModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Wallet_ExchangeModel : NSObject

@property (nonatomic, copy)NSString *back_id;//兑换列表id
@property (nonatomic, copy)NSString *back_number;//兑换编号
@property (nonatomic, copy)NSString *back_money;// 金额
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *uname;//用户名字
@property (nonatomic, copy)NSString *addtime;//兑换时间
@property (nonatomic, copy)NSString *updatetime;//审核时间
@property (nonatomic, copy)NSString *back_status;// 0审核失败  1审核成功 2未审核
@property (nonatomic, copy)NSString *reason;//审核失败原因
@property (nonatomic, copy)NSString *bank_id;// 银行卡id
@property (nonatomic, copy)NSString *backtype;// 回购类型 1余额  2积分（不用 以前设定有积分、现在没有）
@property (nonatomic, copy)NSString *realy_money;//提取的实际现金
@property (nonatomic, copy)NSString *counter;//回购手续费
@property (nonatomic, copy)NSString *del;//是否删除 0否 1是
@property (nonatomic, copy)NSString *time;//月份


@property (nonatomic, assign)CGFloat cellHeight;


@end
