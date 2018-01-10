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
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;//共筹  参与人数
@property (weak, nonatomic) IBOutlet UIView *moneyDetailView;//资金明细
@property (weak, nonatomic) IBOutlet UILabel *costLabel;//耗资Label

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
    
}

/**
 模型赋值
 */
- (void)setModel:(GLMine_NotSaleModel *)model{
    _model = model;
    
    [self.projectImageV sd_setImageWithURL:[NSURL URLWithString:model.picName] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.projectNameLabel.text = model.projectName;
    self.projectDetailLabel.text = model.detail;
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"共筹 %@",model.raise];
    self.costLabel.text = [NSString stringWithFormat:@"耗资 %@", model.cost];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",model.date];
    
    switch ([model.insure integerValue] == 0) {
        case 0:
        {
            self.insureLabel.text = @"个人保障";
        }
            break;
        case 1:
        {
            self.insureLabel.text = @"官方保障";
        }
            break;
        default:
            break;
    }
    
    switch ([model.status integerValue]) {//0:项目筹款中 1:项目筹款失败 2:项目筹款完成 3:项目进行中 4:项目完成 5:项目暂停 6:项目失败 7:项目结束
        case 0://项目筹款中
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
            
            self.dateLabel.text = @"筹款中";
        }
            break;
        case 1://项目筹款失败
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
            
            self.statusLabel.text = @"筹款失败";
        }
            break;
        case 2://项目筹款完成
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
            
            self.dateLabel.text = @"筹款完成";
        }
            break;
        case 3://项目进行中
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
            
            self.dateLabel.text = @"进行中";

        }
            break;
        case 4://项目完成
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
            
            self.statusLabel.text = @"项目完成";
        }
            break;
        case 5://项目暂停
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
            
            self.statusLabel.text = @"项目暂停";
        }
            break;
        case 6://项目失败
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;
            
            self.statusLabel.text = @"项目失败";
        }
            break;
        case 7://项目结束
        {
            self.insureView.hidden = YES;
            self.insureLabel.hidden = YES;
            self.bottomView.hidden = YES;
            self.dateLabel.hidden = YES;
            self.maskView.hidden = NO;
            self.statusLabel.hidden = NO;

            self.statusLabel.text = @"项目结束";
        }
            break;
            
        default:
        {
            self.insureView.hidden = NO;
            self.insureLabel.hidden = NO;
            self.bottomView.hidden = NO;
            self.dateLabel.hidden = NO;
            self.maskView.hidden = YES;
            self.statusLabel.hidden = YES;
            
            self.dateLabel.text = @"进行中";
        }
            break;
    }
    
    
}

@end
