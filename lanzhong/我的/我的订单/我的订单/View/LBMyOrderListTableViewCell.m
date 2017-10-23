//
//  LBMyOrderListTableViewCell.m
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "LBMyOrderListTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation LBMyOrderListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)click:(id)sender {
    
    if (_delegete && [_delegete respondsToSelector:@selector(applyForReturn:section:)]) {
        [_delegete applyForReturn:self.index section:self.section];
    }
}

//查看进度
//- (void)tapgestureEvent:(UITapGestureRecognizer *)sender {
//    
//    if (_delegete && [_delegete respondsToSelector:@selector(clickTapgesture)]) {
//        
//        [_delegete clickTapgesture];
//    }
//}

-(void)setMyorderlistModel:(LBMyOrdersListModel *)myorderlistModel{
    _myorderlistModel = myorderlistModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:myorderlistModel.must_thumb] placeholderImage:[UIImage imageNamed:@"熊"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",myorderlistModel.goods_name];
    self.numberLabel.text = [NSString stringWithFormat:@"X %@",myorderlistModel.goods_num];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",myorderlistModel.goods_discount];
    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",myorderlistModel.title];
    
}

-(void)setMyorderRebateModel:(LBMyorderRebateModel *)myorderRebateModel{
    _myorderRebateModel = myorderRebateModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:_myorderRebateModel.thumb] placeholderImage:[UIImage imageNamed:@"planceholder"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",_myorderRebateModel.goods_name];
    self.numberLabel.text = [NSString stringWithFormat:@"X %@",_myorderRebateModel.goods_num];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",_myorderRebateModel.goods_price];
//    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",myorderRebateModel.title];
    
}

@end
