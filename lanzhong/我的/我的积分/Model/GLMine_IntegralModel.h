//
//  GLMine_IntegralModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_IntegralModel : NSObject

@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *info;//描述 如果是项目这里就是项目描述
@property (nonatomic, copy)NSString *time;//时间
@property (nonatomic, copy)NSString *money;//用掉的积分 这里是负数  其他地方是正数

@end
