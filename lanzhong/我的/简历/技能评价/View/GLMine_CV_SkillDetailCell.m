//
//  GLMine_CV_SkillDetailCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_SkillDetailCell.h"

@interface GLMine_CV_SkillDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@end

@implementation GLMine_CV_SkillDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setModel:(GLMine_CV_skill *)model{
    _model = model;
    self.nameLabel.text = model.skill_name;
    
    switch ([model.mastery integerValue]) {//熟练度1了解 2掌握 3熟练 4精通 5专家
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
            self.levelLabel.text = @"熟练";
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

- (IBAction)editClick:(id)sender {
    if ([self.delegete respondsToSelector:@selector(edit:)]) {
        [self.delegete edit:self.index];
    }
}


@end
