//
//  GLMine_AddressAddController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_AddressModel.h"

@interface GLMine_AddressAddController : UIViewController

@property(assign , nonatomic)BOOL isEdit;//判断是否是编辑

@property (nonatomic, strong)GLMine_AddressModel *model;

@end
