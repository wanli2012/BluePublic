//
//  GLMine_WalletDetailCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletDetailCell.h"

@interface GLMine_WalletDetailCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation GLMine_WalletDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLMine_Wallet_ExchangeModel *)model{
    _model = model;
    
    self.detailLabel.text = [formattime formateTimeOfDate3:model.addtime];
    self.moneyLabel.text = [NSString stringWithFormat:@"兑换:¥ %@",model.back_money];
    self.reasonLabel.text = [NSString stringWithFormat:@"原因:%@",model.reason];
    self.actuallyGetLabel.text = [NSString stringWithFormat:@"实得:¥ %@",model.realy_money];
    
    switch ([model.back_status integerValue]) {
        case 0:
        {
            self.titleLabel.text = @"审核失败";
        }
            break;
        case 1:
        {
            self.titleLabel.text = @"审核成功";
        }
            break;
        case 2:
        {
            self.titleLabel.text = @"未审核";
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setRechargeModel:(GLMine_Wallet_RechargeModel *)rechargeModel{
    _rechargeModel = rechargeModel;
    
    switch ([rechargeModel.pay_type integerValue]) {
        case 1:
        {
            self.titleLabel.text = @"支付宝充值";
            
        }
            break;
        case 2:
        {
             self.titleLabel.text = @"微信充值";
        }
            break;
            
        default:
            break;
    }
    
    self.detailLabel.text = [formattime formateTimeOfDate3:rechargeModel.addtime];
    self.moneyLabel.text = [NSString stringWithFormat:@"充值:¥ %@",rechargeModel.money];

}

@end
