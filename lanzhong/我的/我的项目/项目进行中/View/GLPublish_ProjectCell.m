//
//  GLPublish_ProjectCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ProjectCell.h"

@interface GLPublish_ProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;//蒙版

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *applyBrokeView;
@property (weak, nonatomic) IBOutlet UILabel *brokeLabel;
@property (weak, nonatomic) IBOutlet UIView *brokeLineView;

@property (weak, nonatomic) IBOutlet UIView *insureView;
@property (weak, nonatomic) IBOutlet UILabel *insureLabel;

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
    
    //切单个圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.insureView.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.insureView.bounds;
    maskLayer.path = maskPath.CGPath;
    
    self.insureView.layer.mask = maskLayer;
    
    //破产申请 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(broke)];
    [self.applyBrokeView addGestureRecognizer:tap];
    
}

/**
 申请破产 调代理方法
 */
- (void)broke{
    if ([self.delegate respondsToSelector:@selector(broke:)]) {
        [self.delegate broke:self.index];
    }
}
/**
 资金动向
 
 */
- (IBAction)fundTrend:(id)sender {
   
    if ([self.delegate respondsToSelector:@selector(fundList:)]) {
        [self.delegate fundList:self.index];
    }
    
}

/**
 支持列表

 */
- (IBAction)clici:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(surportList:)]) {
        [self.delegate surportList:self.index];
    }
}

/**
 模型赋值

 @param model 传入的模型
 */
- (void)setModel:(GLPublish_InReViewModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.sev_photo];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.info;
    
    ///这里是写保障方的赋值  接口还没做好
    
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


@end
