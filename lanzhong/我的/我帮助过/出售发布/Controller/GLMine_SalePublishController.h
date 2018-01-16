//
//  GLMine_SalePublishController.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ParticpateModel.h"

@interface GLMine_SalePublishController : UIViewController

@property (nonatomic, copy)NSString *item_id;

@property (nonatomic, strong)GLMine_ParticpateModel *model;

@property (nonatomic, assign)NSInteger type;//1:出售(可出售) 2:编辑(售卖中)

@end
