//
//  GLMine_BillCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_BillCell.h"

@interface GLMine_BillCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;

@end

@implementation GLMine_BillCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLMine_BillModel *)model{
    _model = model;
    
    self.nameabel.text = model.title;
    self.dateLabel.text = [formattime formateTimeOfDate4:model.time];
    
    switch ([model.type integerValue]) {//类型 1商品购买 2项目赔付 3项目收益 4项目转让 5.兑换 6.充值
        case 1: case 5:
        {
            self.incomeLabel.text = [NSString stringWithFormat:@"- %@",model.money];
            
        }
            break;
        case 2:case 3:case 4:case 6:
        {
            self.incomeLabel.text = [NSString stringWithFormat:@"+ %@",model.money];
            
        }
            break;
            
        default:
            break;
    }
}

@end
