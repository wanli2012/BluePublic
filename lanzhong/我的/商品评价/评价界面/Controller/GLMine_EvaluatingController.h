//
//  GLMine_EvaluatingController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_EvaluateModel.h"

typedef void(^GLMine_EvaluatingControllerBlock)();

@interface GLMine_EvaluatingController : UIViewController

@property (nonatomic, strong)GLMine_EvaluateModel *model;

@property (nonatomic, copy)GLMine_EvaluatingControllerBlock block;

@end
