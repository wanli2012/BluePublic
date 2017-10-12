//
//  GLPublish_ReviewCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ReviewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLPublish_ReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//项目图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//详情
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格

@end

@implementation GLPublish_ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.info;
    self.priceLabel.text = model.admin_money;
    
}

@end
