//
//  GLBusiniessCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiniessCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLBusiniessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;//图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题
@property (weak, nonatomic) IBOutlet UILabel *examineLabel;//审核状态
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;//发布人

@property (weak, nonatomic) IBOutlet UIView *progressView;//进度条View
@property (weak, nonatomic) IBOutlet UIView *bgProgressView;//进度条背景
@property (weak, nonatomic) IBOutlet UILabel *pesentLabel;//百分比Label

@property (weak, nonatomic) IBOutlet UILabel *targetMoneyLabel;//目标金额
@property (weak, nonatomic) IBOutlet UILabel *participationLabel;//参与人数
@property (weak, nonatomic) IBOutlet UILabel *raisedMoneyLabel;//已筹金额
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;

@end

@implementation GLBusiniessCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLCircle_item_dataModel *)model{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    if (self.imageV.image == nil) {
        self.imageV.image = [UIImage imageNamed:PlaceHolderImage];
    }
    self.titleLabel.text = model.title;
    self.publishLabel.text = model.issue;
    

    NSMutableAttributedString *admin_moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"目标:%@元",model.admin_money]];
    [admin_moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.admin_money.length)];
    self.targetMoneyLabel.attributedText = admin_moneyStr;
    
    
    NSMutableAttributedString *draw_moneyStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已筹:%@元",model.draw_money]];
    [draw_moneyStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.draw_money.length)];
    self.raisedMoneyLabel.attributedText = draw_moneyStr;
    
    self.participationLabel.text = [NSString stringWithFormat:@"参与人数:%@", model.invest_count];
    
    
    CGFloat ratio;
    if ([model.admin_money floatValue] == 0) {
        ratio = 0.f;
    }else{
        ratio = [model.draw_money floatValue]/[model.admin_money floatValue];
    }
    self.pesentLabel.text = [NSString stringWithFormat:@"%.2f%%",ratio * 100];
    self.progressViewWidth.constant = self.bgProgressView.width * ratio;
    
    self.dateLabel.text = [formattime formateTimeOfDate3:model.time];
//1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败  6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
    switch ([model.state integerValue]) {
        case 1:
        {
             self.examineLabel.text = @"审核中";
        }
            break;
        case 2:
        {
            self.examineLabel.text = @"审核失";
        }
            break;
        case 3:
        {
            self.examineLabel.text = @"审核成功";
        }
            break;
        case 4:
        {
            self.examineLabel.text = @"筹款停止";
        }
            break;
        case 5:
        {
            self.examineLabel.text = @"筹款失败";
        }
            break;
        case 6:
        {
            self.examineLabel.text = @"筹款完成";
        }
            break;
        case 7:
        {
            self.examineLabel.text = @"项目进行";
        }
            break;
        case 8:
        {
            self.examineLabel.text = @"项目暂停";
        }
            break;
        case 9:
        {
            self.examineLabel.text = @"项目失败";
        }
            break;
        case 10:
        {
            self.examineLabel.text = @"项目完成";
        }
            break;
            
        default:
            break;
    }
   
    
}


@end
