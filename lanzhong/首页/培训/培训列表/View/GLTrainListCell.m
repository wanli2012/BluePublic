//
//  GLTrainListCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTrainListCell.h"
#import "UIButton+SetEdgeInsets.h"
@interface GLTrainListCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;//报名
@property (weak, nonatomic) IBOutlet UIView *bgView;//背景view

@end

@implementation GLTrainListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5.f;
    
}
- (void)setModel:(GLTrainListModel *)model{
    _model = model;
    self.titleLabel.text = model.train_name;
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ - %@",[formattime formateTimeOfDate3:model.start_time],[formattime formateTimeOfDate3:model.end_time]];
    self.numberLabel.text = [NSString stringWithFormat:@"剩余人数:%@",model.surplus_count];
    
    if ([model.is_enrol integerValue] == 1) {
        [self.signUpBtn setTitle:@"已报名" forState:UIControlStateNormal];
        
    }else{
        [self.signUpBtn setTitle:@"报名" forState:UIControlStateNormal];
        [self.signUpBtn setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
        [self.signUpBtn horizontalCenterTitleAndImage:5];
    }
}

//报名
- (IBAction)signUp:(id)sender {
    if ([self.delegate respondsToSelector:@selector(signUp:)]) {
        [self.delegate signUp:self.index];
    }
}

@end
