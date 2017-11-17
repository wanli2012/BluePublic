//
//  GLMine_WalletModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wallet_back_info : NSObject

@property (nonatomic, copy)NSString *bank_id;//银行id
@property (nonatomic, copy)NSString *uid;//用户id
@property (nonatomic, copy)NSString *name;//持卡人名称
@property (nonatomic, copy)NSString *bank_num;//银行卡号
@property (nonatomic, copy)NSString *bank_name;//开户银行
@property (nonatomic, copy)NSString *bank_branch;//支行地址
@property (nonatomic, copy)NSString *addtime;//添加时间
@property (nonatomic, copy)NSString *del;//是否删除  1是  0否


@end

@interface GLMine_WalletModel : NSObject

@property (nonatomic, copy)NSString *umonry;//  余额
@property (nonatomic, copy)NSString *real_state;//实名认证状态 0未认证  1成功   2失败   3审核中
@property (nonatomic, copy)NSMutableArray <Wallet_back_info *>*back_info;
@property (nonatomic, copy)NSString *back_counter;// 手续费

@end
