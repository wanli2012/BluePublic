//
//  GLMine_Wallet_RechargeModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_Wallet_RechargeModel : NSObject

@property (nonatomic, copy)NSString *recharge_id;//充值记录id
@property (nonatomic, copy)NSString *add_num;//充值编号
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *money;//充值金额
@property (nonatomic, copy)NSString *is_pay;//是否支付 1是 0否'
@property (nonatomic, copy)NSString *pay_type;// 支付方式1支付宝  2微信
@property (nonatomic, copy)NSString *addtime;//充值时间
@property (nonatomic, copy)NSString *time;//月份


@end
