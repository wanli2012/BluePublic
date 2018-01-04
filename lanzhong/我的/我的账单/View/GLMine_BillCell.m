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
    
    self.nameabel.text = model.name;
    self.dateLabel.text = model.date;
    self.incomeLabel.text = [NSString stringWithFormat:@"+ %@",model.income];
}

@end
