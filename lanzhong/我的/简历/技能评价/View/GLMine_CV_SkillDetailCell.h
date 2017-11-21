//
//  GLMine_CV_SkillDetailCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CV_DetailModel.h"

@protocol GLMine_CV_SkillDetailCellDelegete <NSObject>

- (void)edit:(NSInteger)index;

@end

@interface GLMine_CV_SkillDetailCell : UITableViewCell

@property (nonatomic, strong)GLMine_CV_skill *model;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLMine_CV_SkillDetailCellDelegete> delegete;

@end
