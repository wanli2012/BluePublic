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
    self.applyReturnBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.applyReturnBtn.layer.borderWidth = 0.5;
}

- (IBAction)click:(id)sender {
    
    if (_delegete && [_delegete respondsToSelector:@selector(applyForReturn:section:)]) {
        [_delegete applyForReturn:self.index section:self.section];
    }
}

-(void)setMyorderlistModel:(LBMyOrdersListModel *)myorderlistModel{
    _myorderlistModel = myorderlistModel;
    
    [self.imagev sd_setImageWithURL:[NSURL URLWithString:myorderlistModel.must_thumb] placeholderImage:[UIImage imageNamed:@"熊"]];
    self.namelb.text = [NSString stringWithFormat:@"%@",myorderlistModel.goods_name];
    self.numberLabel.text = [NSString stringWithFormat:@"x %@",myorderlistModel.goods_num];
    self.priceLb.text = [NSString stringWithFormat:@"价格: %@",myorderlistModel.goods_discount];
    self.specLabel.text = [NSString stringWithFormat:@"规格:%@",myorderlistModel.title];
    
}

@end
