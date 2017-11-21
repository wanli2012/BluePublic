//
//  GLMine_CV_BaseCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_BaseCell.h"

@interface GLMine_CV_BaseCell()
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation GLMine_CV_BaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(GLMine_CV_basic *)model{
    _model = model;

    if ([model.sex integerValue] == 1) {
        self.sexLabel.text = @"男";
    }else{
        self.sexLabel.text = @"女";
    }
    
    self.educationLabel.text = model.education;
    self.workLifeLabel.text = model.work;
    self.birthLabel.text = model.birth_time;
    self.cityLabel.text = model.city_name;
    self.phoneLabel.text = model.phone;
    self.emailLabel.text = model.email;
}

@end
