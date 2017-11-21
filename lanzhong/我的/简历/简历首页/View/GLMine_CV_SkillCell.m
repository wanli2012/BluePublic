//
//  GLMine_CV_SkillCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_SkillCell.h"

@interface GLMine_CV_SkillCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation GLMine_CV_SkillCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setModel:(GLMine_CV_skill *)model{
    _model = model;
    self.titleLabel.text = model.skill_name;
    switch ([model.mastery integerValue]) {
        case 1:
        {
            self.levelLabel.text = @"了解";
        }
            break;
        case 2:
        {
            self.levelLabel.text = @"掌握";
        }
            break;
        case 3:
        {
            self.levelLabel.text = @"熟悉";
        }
            break;
        case 4:
        {
            self.levelLabel.text = @"精通";
        }
            break;
        case 5:
        {
            self.levelLabel.text = @"专家";
        }
            break;
        default:
            break;
    }
}

@end
