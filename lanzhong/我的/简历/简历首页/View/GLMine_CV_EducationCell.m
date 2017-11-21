//
//  GLMine_CV_EducationCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_EducationCell.h"

@interface GLMine_CV_EducationCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMine_CV_EducationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(GLMine_CV_teach *)model{
    _model = model;
    self.timeLabel.text = model.leave_time;
    self.schoolLabel.text = model.school;
    self.contentLabel.text = [NSString stringWithFormat:@"%@/%@",model.education_leave,model.major];
}


@end
