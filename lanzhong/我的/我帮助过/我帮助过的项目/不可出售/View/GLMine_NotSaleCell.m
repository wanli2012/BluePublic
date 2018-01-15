//
//  GLMine_NotSaleCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_NotSaleCell.h"

@interface GLMine_NotSaleCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *projectImageV;//项目图片
@property (weak, nonatomic) IBOutlet UIView *insureView;//保障
@property (weak, nonatomic) IBOutlet UILabel *insureLabel;//保障方
@property (weak, nonatomic) IBOutlet UIView *bottomView;//底部view
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UIView *maskView;//遮罩
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//项目状态imageV
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//项目状态label

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名称
@property (weak, nonatomic) IBOutlet UILabel *projectDetailLabel;//项目详情
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;//共筹  耗资
@property (weak, nonatomic) IBOutlet UIView *moneyDetailView;//资金明细

@end

@implementation GLMine_NotSaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5.f;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moneyDetail)];
    [self.moneyDetailView addGestureRecognizer:tap];
    
}

/**
 资金明细
 */
- (void)moneyDetail{
    if ([self.delegate respondsToSelector:@selector(moneyDetail:)]){
        [self.delegate moneyDetail:self.index];
    }
}

/**
 模型赋值
 */
- (void)setModel:(GLMine_NotSaleModel *)model{
    _model = model;

    [self.projectImageV sd_setImageWithURL:[NSURL URLWithString:model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.projectNameLabel.text = model.title;
    self.projectDetailLabel.text = model.info;
    
    
    NSString *startDate = [formattime formateTimeOfDate4:model.s_time];
    NSString *endDate = [[formattime formateTimeOfDate4:model.need_time] substringFromIndex:5];
    NSString *date = [NSString stringWithFormat:@"%@-%@",startDate,endDate];
    self.dateLabel.text = date;
    
    
    NSString *money;
    if([model.admin_money floatValue] > 10000){
        money = [NSString stringWithFormat:@"%.2f万",[model.admin_money floatValue]/10000];
    }else{
        money = [NSString stringWithFormat:@"%.2f",[model.admin_money floatValue]];
    }

    
    switch ([model.state integerValue]) {//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败  6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成 11项目结束'
        
        case 1://1待审核(审核中)
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",money];
            self.dateLabel.text = @"审核中";
        }
            break;
        case 2://审核失败
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",money];
            self.dateLabel.text = @"审核失败";
        }
            break;
        case 3://项目筹款中
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",money];
            self.dateLabel.text = @"筹款中";
        }
            break;
        case 4://筹款停止
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",money];
            self.statusLabel.text = @"筹款停止";
        }
            break;
        case 5://项目筹款失败
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",money];
            self.statusLabel.text = @"筹款失败";
        }
            break;
        case 6://项目筹款完成
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
//            self.moneyDetailView.hidden = YES;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"已筹:%@",money];
            self.statusLabel.text = @"筹款完成";
        }
            break;
        case 7://项目进行中
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
//            self.moneyDetailView.hidden = NO;
            
            self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹款:%@",money];
            self.dateLabel.text = @"进行中";

        }
            break;
        case 10://项目完成
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = NO;

            self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹款:%@",money];
            self.dateLabel.text = @"项目完成";
        }
            break;
        case 8://项目暂停
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = NO;

            self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹款:%@",money];
            self.dateLabel.text = @"项目暂停";
        }
            break;
        case 9://项目失败
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;

            self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹款:%@",money];
            self.dateLabel.text = @"项目失败";
        }
            break;
        case 11://项目结束
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
//            self.moneyDetailView.hidden = YES;

            self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹款:%@",money];
            self.dateLabel.text = @"项目结束";
        }
            break;

        default:
        
            break;
    }
    
    
    switch ([model.ensure_type integerValue]) {//百万保障类型 1无保障计划  2项目发布人自保  3项目出保
        case 1:
        {
            self.insureView.hidden = YES;
        }
            break;
        case 2:
        {
            self.insureLabel.text = @"个人保障";
        }
            break;
        case 3:
        {
            self.insureLabel.text = @"官方保障";
        }
            break;
        default:
            break;
    }

}

@end
