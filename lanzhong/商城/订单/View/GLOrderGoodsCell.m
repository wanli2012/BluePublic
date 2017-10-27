//
//  GLOrderGoodsCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/26.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLOrderGoodsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLOrderGoodsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;

@end

@implementation GLOrderGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLConfirmOrderModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.must_thumb];
    [_imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    _nameLabel.text = model.goods_name;
    _priceLabel.text = [NSString stringWithFormat:@"单价:%@",model.goods_price];
    _sumLabel.text = [NSString stringWithFormat:@"数量:x%@",model.num];
    _detailLabel.text = [NSString stringWithFormat:@"%@",model.goods_info];
    _specLabel.text = [NSString stringWithFormat:@"规格:%@",model.spec_title];
}

@end
