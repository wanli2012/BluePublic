//
//  GLMine_ParticipateCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ParticipateCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_ParticipateCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *picimageV;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end

@implementation GLMine_ParticipateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLMine_ParticpateModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.sev_photo];
    [self.picimageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.title;
    self.infoLabel.text = model.info;
    self.moneyLabel.text = [NSString stringWithFormat:@"目标金额:%@",model.i_money];
    
    switch ([model.state integerValue]) {//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败 6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
        case 1:
        {
            self.statuslabel.text = @"审核中";
        }
            break;
        case 2:
        {
            self.statuslabel.text = @"审核失败";
        }
            break;
        case 3:
        {
            self.statuslabel.text = @"审核成功";
        }
            break;
        case 4:
        {
            self.statuslabel.text = @"筹款停止";
        }
            break;
        case 5:
        {
            self.statuslabel.text = @"筹款失败";
        }
            break;
        case 6:
        {
            self.statuslabel.text = @"筹款完成";
        }
            break;
        case 7:
        {
            self.statuslabel.text = @"项目进行";
        }
            break;
        case 8:
        {
            self.statuslabel.text = @"项目暂停";
        }
            break;
        case 9:
        {
            self.statuslabel.text = @"项目失败";
        }
            break;
        case 10:
        {
            self.statuslabel.text = @"项目完成";
        }
            break;
            
        default:
            break;
    }
}

@end
