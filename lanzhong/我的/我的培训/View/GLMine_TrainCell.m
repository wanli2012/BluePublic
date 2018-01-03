//
//  GLMine_TrainCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_TrainCell.h"

@interface GLMine_TrainCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation GLMine_TrainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 5.f;
}
- (void)setModel:(GLMine_TrainModel *)model{
    _model = model;
    self.nameLabel.text = model.train_name;
    self.dateLabel.text = [NSString stringWithFormat:@"报名时间: %@ - %@",[formattime formateTimeOfDate4:model.start_time],[formattime formateTimeOfDate4:model.end_time]];
    
    switch ([model.open integerValue]) {//培训是否开启 1开启 2关闭
        case 1:
        {
            self.signLabel.text = @"开启";
        }
            break;
        case 2:
        {
            self.signLabel.text = @"关闭";
        }
            break;
            
        default:
            break;
    }
}

@end
