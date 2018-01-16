//
//  GLMine_SaleRecordCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SaleRecordCell.h"

@interface GLMine_SaleRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//项目名
@property (weak, nonatomic) IBOutlet UILabel *personLabel;//被转让人
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;//收支
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@end

@implementation GLMine_SaleRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLMine_SaleRecordModel *)model{
    _model = model;
    
    self.nameLabel.text = model.title;
    self.personLabel.text = model.name;
    self.dateLabel.text = [formattime formateTimeOfDate4:model.time];
    
    switch (model.type) {
        case 2:
        {
            self.incomeLabel.text = [NSString stringWithFormat:@"+ %@",model.money];
        }
            break;
        case 3:
        {
             self.incomeLabel.text = [NSString stringWithFormat:@"- %@",model.money];
        }
            break;
            
        default:
            break;
    }
    
}


@end
