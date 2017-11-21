//
//  GLMine_CV_AddSkillController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CV_DetailModel.h"

@interface GLMine_CV_AddSkillController : UIViewController

@property (nonatomic, strong)GLMine_CV_skill *model;

@property (nonatomic, assign)NSInteger type;//技能id 添加技能传0 修改技能id传返回id

@end
