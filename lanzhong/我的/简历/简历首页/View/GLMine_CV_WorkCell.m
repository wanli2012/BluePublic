//
//  GLMine_CV_WorkCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_WorkCell.h"

@interface GLMine_CV_WorkCell ()

@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *workPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *workContentLabel;

@end

@implementation GLMine_CV_WorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)setModel:(GLMine_CV_live *)model{
    _model = model;
    
    self.workTimeLabel.text = model.work_time;
    self.workPlaceLabel.text = [NSString stringWithFormat:@"公司:%@",model.company_name];
    self.positionLabel.text = [NSString stringWithFormat:@"职位:%@",model.career_name];
    self.workContentLabel.text = model.work_content;
}

@end
