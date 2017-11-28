//
//  GLMine_CV_WorkCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GLMine_CV_DetailModel.h"

@interface GLMine_CV_WorkCell : UITableViewCell

@property (nonatomic, strong)GLMine_CV_live *model;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@end
