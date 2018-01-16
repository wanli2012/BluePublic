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
@property (weak, nonatomic) IBOutlet UIView *bgView;

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
    
    self.bgView.layer.cornerRadius = 5.f;
}

- (void)setModel:(GLCircle_item_dataModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.owerLabel.text = model.nickname;
//    self.dateLabel.text = model.addtime;
    self.dateLabel.text = [formattime formateTimeOfDate4:model.addtime];
    self.detailLabel.text = model.info;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    if ([model.ensure_type integerValue] == 1) {
        self.ensureLabel.text = @"无保障计划";
    }else if([model.ensure_type integerValue] == 2){
        self.ensureLabel.text = @"个人保障";
    }else{
        self.ensureLabel.text = @"官方保障";
    }

    
    NSMutableAttributedString *cost = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"耗资:%@",model.admin_money]];
    [cost addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.admin_money.length)];
    self.costLabel.attributedText = cost;

    
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"估价:%@",model.attorn_money]];
    [price addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.attorn_money.length)];
    self.priceLabel.attributedText = price;
    
}


@end
