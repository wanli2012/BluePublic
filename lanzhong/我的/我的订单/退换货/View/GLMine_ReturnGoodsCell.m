//
//  GLMine_ReturnGoodsCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/24.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ReturnGoodsCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_ReturnGoodsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation GLMine_ReturnGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_ReturnGoodsModel *)model{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.must_thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    
    self.titleLabel.text = model.goods_name;
    self.specLabel.text = model.title;
    self.priceLabel.text = [NSString stringWithFormat:@"价格:%@",model.total_price];
    self.numLabel.text = [NSString stringWithFormat:@"x %@",model.goods_num];
    //退货状态  0无申请  1申请退货  2管理员同意  3管理员拒绝  4用户已提交退货信息   5管理员审核确定退货退款操作
    NSString *string;
    switch ([model.refunds_state integerValue]) {
        case 0://0无申请
        {
            string = @"申请退货";
            self.applyReturnBtn.enabled = NO;
        }
            break;
        case 1://1申请退货
        {
            string = @"退货申请中";
            self.applyReturnBtn.enabled = NO;
        }
            break;
        case 2://2管理员同意
        {
            string = @"提交退货单";
            self.applyReturnBtn.enabled = YES;
            self.applyReturnBtn.layer.borderColor = MAIN_COLOR.CGColor;
            self.applyReturnBtn.layer.borderWidth = 0.5;
        }
            break;
        case 3://3管理员拒绝
        {
            string = @"重新申请";
            self.applyReturnBtn.enabled = NO;
        }
            break;
        case 4://4用户已提交退货信息
        {
            string = @"等待退款";
            self.applyReturnBtn.enabled = NO;
        }
            break;
        case 5://5管理员审核确定退货退款操作
        {
            string = @"已退款";
            self.applyReturnBtn.enabled = NO;
        }
            break;
            
        default:
            break;
    }
     [self.applyReturnBtn setTitle:string forState:UIControlStateNormal];

}

- (IBAction)click:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(returnGoods:)]) {
        [self.delegate returnGoods:self.index];
    }
    
}

@end
