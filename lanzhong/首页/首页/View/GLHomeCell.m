//
//  GLHomeCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLHomeCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;//
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;//发布平台
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//目标金额
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;//人数

@end

@implementation GLHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.clipsToBounds = YES;
    
}

- (void)setModel:(GLHome_groom_itemModel *)model{
    _model = model;
    
    switch ([model.stop integerValue]) {
        case 1:
        {
            self.statusLabel.text = @"正常";
        }
            break;
        case 2:
        {
            self.statusLabel.text = @"禁止";
        }
            break;
        case 3:
        {
            self.statusLabel.text = @"已完成";
        }
            break;
        default:
            break;
    }

    if([model.uid integerValue] == 0){
        self.publishLabel.text = @"官方发布";
    }else{
        self.publishLabel.text = @"个人发布";
    }
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/414/h/200",model.sev_photo];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@元",model.admin_money];
    self.personNumLabel.text = [NSString stringWithFormat:@"%@人", model.invest_count];
}


@end
