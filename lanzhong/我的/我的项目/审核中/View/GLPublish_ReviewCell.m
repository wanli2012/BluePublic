//
//  GLPublish_ReviewCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ReviewCell.h"

@interface GLPublish_ReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//项目图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//详情
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

@end

@implementation GLPublish_ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/200",model.sev_photo];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.info;
    
    if(model.isReviewed){
        self.priceLabel.text = model.budget_money;
    }else{
        self.priceLabel.text = model.admin_money;
    }

    switch ([model.state integerValue]) {
        case 2:
        {
            self.bgView.hidden = NO;
            self.signLabel.hidden = YES;
            self.signImageV.hidden = NO;
            
            self.signImageV.image = [UIImage imageNamed:@"auditfailure"];
        }
            break;
        case 5:
        {
            
            self.bgView.hidden = NO;
            self.signLabel.hidden = YES;
            self.signImageV.hidden = NO;
            
            self.signImageV.image = [UIImage imageNamed:@"fundraisingfailure"];
            
        }
            break;
        case 8:
        {

            self.bgView.hidden = NO;
            self.signLabel.hidden = NO;
            self.signImageV.hidden = YES;
            
            self.signLabel.text = @"已暂停";
        }
            break;
        case 9:
        {
            self.bgView.hidden = NO;
            self.signImageV.hidden = NO;
            self.signLabel.hidden = YES;
            self.targetLabel.hidden = YES;
            self.priceLabel.hidden = YES;
            self.signImageV.image = [UIImage imageNamed:@"projectfailure"];
        }
            break;
            
        default:
            break;
    }
}

- (void)setPayModel:(GLPay_CompletedModel *)payModel{
    _payModel = payModel;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:payModel.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = payModel.title;
    self.detailLabel.text = payModel.info;
    self.titleNameLabel.text = @"支持人数";
    self.priceLabel.text = [NSString stringWithFormat:@"%@人",payModel.invest_count];
    
}

@end
