//
//  GLShoppingCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/3/25.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLShoppingCell.h"


@interface GLShoppingCell ()
@property (weak, nonatomic) IBOutlet UIView *bgViewLayerView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *imageV;//商品图片
@property (weak, nonatomic) IBOutlet UILabel *goodsNamelabel;//商品名称
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;//数量
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *specLabel;//规格

//@property (weak, nonatomic) IBOutlet UIImageView *xiajiaImageV;
//@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//@property (weak, nonatomic) IBOutlet UIView *typeview;

@end

@implementation GLShoppingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 5.f;
    self.bgViewLayerView.layer.cornerRadius = 5.f;

    self.bgView.layer.shadowOpacity = 0.1f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bgView.layer.shadowRadius = 5.0f;

    self.bgViewLayerView.layer.shadowOpacity = 0.1f;
    self.bgViewLayerView.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.bgViewLayerView.layer.shadowRadius = 5.0f;

    self.goodsNamelabel.font = [UIFont systemFontOfSize:15];

}
- (void)setModel:(GLShoppingCartModel *)model {
    _model = model;
//    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    _goodsNamelabel.text = model.goods_name;
    _amountLabel.text =[NSString stringWithFormat:@"x%@",model.num];
    _detailLabel.text = model.goods_info;

    _priceLabel.text = [NSString stringWithFormat:@"¥%@",model.marketprice];
    _specLabel.text = model.title;
    if (_imageV.image == nil) {
        _imageV.image = [UIImage imageNamed:PlaceHolderImage];
    }

    if (model.isSelect == NO) {
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"nochoice1"] forState:UIControlStateNormal];
    }else{
        
        [self.selectedBtn setImage:[UIImage imageNamed:@"mine_choice"] forState:UIControlStateNormal];
    }

}


@end
