//
//  GLMine_IntegralCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_IntegralCell.h"

@interface GLMine_IntegralCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//项目名称
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//项目详情描述
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;//积分收支

@end

@implementation GLMine_IntegralCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLMine_IntegralModel *)model{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.detailLabel.text = model.detail;
    self.dateLabel.text = model.date;
    self.integralLabel.text = [NSString stringWithFormat:@"+%@",model.integral];
    
}

@end
