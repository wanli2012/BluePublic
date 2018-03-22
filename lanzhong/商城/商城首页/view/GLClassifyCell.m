//
//  GLClassifyCell.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/21.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLClassifyCell.h"

@interface GLClassifyCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *jifenimage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pricedistance;

@end

@implementation GLClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLMallModel *)model{
    _model = model;
    
    if ([self.goods_typeName containsString:@"积分"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@",model.goods_discount];
        self.jifenimage.hidden = NO;
        self.pricedistance.constant = 30;
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.goods_discount];
        self.jifenimage.hidden = YES;
        self.pricedistance.constant = 10;
    }
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.must_thumb];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.goods_name;
    if ([model.salenum integerValue] > 10000) {
        self.countLabel.text = [NSString stringWithFormat:@"已售:%.2f万",[model.salenum floatValue]/ 10000.0];
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"已售:%@",model.salenum];
        
    }
}

@end
