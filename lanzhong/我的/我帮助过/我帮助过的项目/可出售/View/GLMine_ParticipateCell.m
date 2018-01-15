//
//  GLMine_ParticipateCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ParticipateCell.h"

@interface GLMine_ParticipateCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *picimageV;//项目图片
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;//保障方
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//项目名字
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;//详情
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//耗资
@property (weak, nonatomic) IBOutlet UILabel *personSumLabel;//参与人数
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期
@property (weak, nonatomic) IBOutlet UILabel *isSaleLabel;//是否是收购的项目
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIButton *saleBtn;//出售
@property (weak, nonatomic) IBOutlet UIView *insureView;

@end

@implementation GLMine_ParticipateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5.f;
    self.saleBtn.layer.cornerRadius = 3.f;
    self.saleBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.saleBtn.layer.borderWidth = 1.f;
    
}

/**
 出售
 */
- (IBAction)sell:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sell:)]) {
        [self.delegate sell:self.index];
    }
}

/**
 模型赋值
 @param model 传入的模型
 */
- (void)setModel:(GLMine_ParticpateModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.sev_photo];
    [self.picimageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.info;
    self.personSumLabel.text = [NSString stringWithFormat:@"参与人数:%@", model.user_count];
    
    
    if(model.s_time.length == 0){
        self.dateLabel.text = @"";
        self.bottomView.hidden = YES;
    }else{
        NSString *startDate = [formattime formateTimeOfDate4:model.s_time];
        NSString *endDate = [[formattime formateTimeOfDate4:model.need_time] substringFromIndex:5];
        NSString *date = [NSString stringWithFormat:@"%@-%@",startDate,endDate];
        self.bottomView.hidden = NO;
        self.dateLabel.text = date;
    }
    
    NSMutableAttributedString *cost = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"耗资:%@",model.admin_money]];
    [cost addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(3,model.admin_money.length)];
    self.moneyLabel.attributedText = cost;
    
    switch ([model.is_sale integerValue]) {//是否是购买来的 1是 0否',
        case 0:
        {
            self.isSaleLabel.hidden = YES;
           
        }
            break;
        case 1:
        {
            self.isSaleLabel.hidden = NO;
        }
            break;
            
        default:
            break;
    }

    switch ([model.type integerValue]) {//0可出售 1不可出售 2出售中
        case 0:
        {
            [self.saleBtn setTitle:@"出售" forState:UIControlStateNormal];
        }
            break;

        case 2:
        {
            [self.saleBtn setTitle:@"操作" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
    switch ([model.ensure_type integerValue]) {//1无保障计划  2项目发布人自保  3项目出保
        case 1:
        {
            self.statuslabel.text = @"无保障计划";
            self.insureView.hidden = YES;
        }
            break;
        case 2:
        {
            self.statuslabel.text = @"个人保障";
            self.insureView.hidden = NO;
        }
            break;
        case 3:
        {
            self.statuslabel.text = @"项目保障";
            self.insureView.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
//    switch ([model.state integerValue]) {//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败 6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
//        case 1:
//        {
//            self.statuslabel.text = @"审核中";
//        }
//            break;
//        case 2:
//        {
//            self.statuslabel.text = @"审核失败";
//        }
//            break;
//        case 3:
//        {
//            self.statuslabel.text = @"审核成功";
//        }
//            break;
//        case 4:
//        {
//            self.statuslabel.text = @"筹款停止";
//        }
//            break;
//        case 5:
//        {
//            self.statuslabel.text = @"筹款失败";
//        }
//            break;
//        case 6:
//        {
//            self.statuslabel.text = @"筹款完成";
//        }
//            break;
//        case 7:
//        {
//            self.statuslabel.text = @"项目进行";
//        }
//            break;
//        case 8:
//        {
//            self.statuslabel.text = @"项目暂停";
//        }
//            break;
//        case 9:
//        {
//            self.statuslabel.text = @"项目失败";
//        }
//            break;
//        case 10:
//        {
//            self.statuslabel.text = @"项目完成";
//        }
//            break;
//
//        default:
//            break;
//    }
    
}

@end
