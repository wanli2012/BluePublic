//
//  GLPublish_ProjectCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ProjectCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLPublish_ProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;//蒙版

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GLPublish_ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    
    self.arrowImageV.hidden = NO;
    self.fundTrendBtn.hidden = NO;
    self.numberLabel.hidden = YES;
    self.suportListBtn.layer.cornerRadius = 5.f;
    
}

//资金动向
- (IBAction)fundTrend:(id)sender {
    
    NSLog(@"资金动向");
}

- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.info;
    
    switch ([model.state integerValue]) {
        case 6:
        {
            
            self.iconImageV.hidden = YES;
            self.numberLabel.hidden = YES;
            self.fundTrendBtn.hidden = YES;
            self.arrowImageV.hidden = YES;
            
            self.signLabel.text = [NSString stringWithFormat:@"%@--%@",[formattime formateTimeOfDate3:model.time],[formattime formateTimeOfDate3:model.need_time]];
            self.signLabel.font = [UIFont systemFontOfSize:10];

            
        }
            break;
        case 7:
        {
            self.iconImageV.hidden = YES;
            self.signLabel.text = @"进行中";
            
            self.iconImageV.hidden = YES;
            self.numberLabel.hidden = YES;
            self.fundTrendBtn.hidden = NO;
            self.arrowImageV.hidden = NO;
            
        }
            break;
        case 10:
        {
            self.iconImageV.hidden = NO;
            self.numberLabel.hidden = NO;
            self.fundTrendBtn.hidden = YES;
            self.arrowImageV.hidden = YES;
            
            self.signLabel.text = [NSString stringWithFormat:@"%@--%@",[formattime formateTimeOfDate3:model.time],[formattime formateTimeOfDate3:model.need_time]];
            self.signLabel.font = [UIFont systemFontOfSize:10];

        }
            break;
            
        default:
            break;
    }
    
    
    
    NSString *str1 = [NSString stringWithFormat:@"%@",model.admin_money];
    // 创建Attributed
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共筹 %@",str1]];
    // 需要改变的区间
    NSRange range1 = NSMakeRange(3, str1.length);
    // 改变颜色
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    // 改变字体大小及类型
    [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range1];
    [self.moneyLabel setAttributedText:noteStr1];
    
    
    
    NSString *str = [NSString stringWithFormat:@"%@人",model.invest_count];
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参与人数 %@",str]];
    // 需要改变的区间
    NSRange range = NSMakeRange(5, str.length);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    // 为label添加Attributed
    [self.numberLabel setAttributedText:noteStr];
    
    
}
- (IBAction)clici:(id)sender {
    if ([self.delegate respondsToSelector:@selector(surportList:)]) {
        [self.delegate surportList:self.index];
    }
}

@end
