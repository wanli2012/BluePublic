//
//  GLPublish_ProjectInProgressCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FundraisingCell.h"
#import "formattime.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLPublish_FundraisingCell ()

@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *persentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//项目图
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *targetMoneyLabel;//目标金额
@property (weak, nonatomic) IBOutlet UILabel *raisedMoneyLabel;//已筹金额
@property (weak, nonatomic) IBOutlet UILabel *invest_countLabel;//参与人数
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题

@end

@implementation GLPublish_FundraisingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    
    self.ballView.layer.cornerRadius = self.ballView.height/2;
    self.ballView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.ballView.layer.borderWidth = 1.f;
    
}

- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    self.dateLabel.text = [formattime formateTimeOfDate3:model.time];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.targetMoneyLabel.text = model.admin_money;
    self.raisedMoneyLabel.text = model.draw_money;
    self.invest_countLabel.text = model.invest_count;
    
    CGFloat persent = [model.draw_money floatValue] / [model.admin_money floatValue];
    self.progressViewWidth.constant = self.progressBgView.width * 0.3;
    self.persentLabel.text = [NSString stringWithFormat:@"%.2f%%",persent * 100];
    
    
}

@end
