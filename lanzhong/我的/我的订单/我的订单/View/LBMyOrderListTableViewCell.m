//
//  LBMyOrderListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LBMyOrderListTableViewCell ()


@end

@implementation LBMyOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)click:(id)sender {
    
    if (_delegete && [_delegete respondsToSelector:@selector(applyForReturn:section:)]) {
        [_delegete applyForReturn:self.index section:self.section];
    }
}

-(void)setMyorderlistModel:(LBMyOrdersListModel *)myorderlistModel{
    _myorderlistModel = myorderlistModel;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",myorderlistModel.must_thumb];
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"熊"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",myorderlistModel.goods_name];
    self.numberLabel.text = [NSString stringWithFormat:@"x %@",myorderlistModel.goods_num];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",myorderlistModel.goods_discount];
    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",myorderlistModel.title];
    //退货状态  0无申请  1申请退货  2管理员同意  3管理员拒绝  4用户已提交退货信息   5管理员审核确定退货退款操作
    NSString *string;
    switch ([myorderlistModel.refunds_state integerValue]) {
        case 0://0无申请
        {
            string = @"申请退货";
            self.applyReturnBtn.enabled = YES;
            self.applyReturnBtn.layer.borderColor = MAIN_COLOR.CGColor;
            self.applyReturnBtn.layer.borderWidth = 0.5;
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
            self.applyReturnBtn.enabled = NO;
        }
            break;
        case 3://3管理员拒绝
        {
            string = @"被拒,请联系客服";
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

@end
