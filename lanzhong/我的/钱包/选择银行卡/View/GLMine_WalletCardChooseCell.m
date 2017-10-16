//
//  GLMine_WalletCardChooseCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletCardChooseCell.h"

@interface GLMine_WalletCardChooseCell ()


@end

@implementation GLMine_WalletCardChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(Wallet_back_info *)model{
    _model = model;
    
    self.bankNameLabel.text = model.bank_name;
    self.bankNumLabel.text = model.bank_num;
}
@end
