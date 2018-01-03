//
//  GLPublish_ProjectInProgressCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FundraisingCell.h"

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
    
    self.suportListBtn.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.sev_photo];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.dateLabel.text = [formattime formateTimeOfDate3:model.time];
    self.titleLabel.text = model.title;
    self.targetMoneyLabel.text = model.admin_money;
    self.raisedMoneyLabel.text = model.draw_money;
    self.invest_countLabel.text = model.invest_count;
    
    CGFloat ratio;
    if ([model.admin_money floatValue] == 0) {
        ratio = 0.f;
    }else{
        ratio = [model.draw_money floatValue]/[model.admin_money floatValue];
    }
    
    self.persentLabel.text = [NSString stringWithFormat:@"%.2f%%",ratio * 100];

    self.progressViewWidth.constant = (kSCREEN_WIDTH - 205) * ratio;
    
}

- (IBAction)suportList:(id)sender {
    if ([self.delegate respondsToSelector:@selector(surportList:)]) {
        [self.delegate surportList:self.index];
    }
}

@end
