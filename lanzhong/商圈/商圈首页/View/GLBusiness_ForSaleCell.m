//
//  GLBusiness_ForSaleCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/4.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_ForSaleCell.h"

@interface GLBusiness_ForSaleCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *ensureLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *owerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@property (weak, nonatomic) IBOutlet UILabel *partLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation GLBusiness_ForSaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLBusiness_ForSaleModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.owerLabel.text = model.contactMan;
    self.dateLabel.text = model.date;
    self.detailLabel.text = model.detail;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if ([model.ensure integerValue] == 1) {
        
        self.ensureLabel.text = @"官方保障";
    }else{
        self.ensureLabel.text = @"个人保障";
    }
    
    
    NSMutableAttributedString *cost = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"耗资:%@",model.cost]];
    [cost addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.cost.length)];
    self.costLabel.attributedText = cost;
    
    NSMutableAttributedString *part = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参与人数:%@",model.canyu]];
    [part addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.canyu.length)];
    self.costLabel.attributedText = part;
    
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"估价:%@",model.gujia]];
    [price addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.gujia.length)];
    self.costLabel.attributedText = price;
    
}


@end
