//
//  GLTalentPoolModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTalentPool_Category : NSObject

@property (nonatomic, copy)NSString *id;
@property (nonatomic, copy)NSString *name;

@end

@interface GLTalentPoolModel : NSObject

@property (nonatomic, copy)NSArray <GLTalentPool_Category *>*money;//期望工资筛选内容
@property (nonatomic, copy)NSArray <GLTalentPool_Category *>*duty;//期望职业筛选内容
@property (nonatomic, copy)NSArray <GLTalentPool_Category *>*work;//工作时间筛选内容

@end
