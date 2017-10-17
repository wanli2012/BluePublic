//
//  GLMine_WalletDetailCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_Wallet_ExchangeModel.h"//兑换模型
#import "GLMine_Wallet_RechargeModel.h"//充值模型

@interface GLMine_WalletDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong)GLMine_Wallet_ExchangeModel *model;

@property (nonatomic, strong)GLMine_Wallet_RechargeModel *rechargeModel;

@end
