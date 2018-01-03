//
//  GLTrainListModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/12/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLTrainListModel : NSObject

@property (nonatomic, copy)NSString *train_id;//培训id
@property (nonatomic, copy)NSString *train_name;//培训标题
@property (nonatomic, copy)NSString *num;//培训核定人数
@property (nonatomic, copy)NSString *train_money;//培训费用
@property (nonatomic, copy)NSString *start_time;//培训开始时间
@property (nonatomic, copy)NSString *end_time;//培训结束时间
@property (nonatomic, copy)NSString *jion_count;//培训已报名人数
@property (nonatomic, copy)NSString *surplus_count;//剩余报名人数
@property (nonatomic, copy)NSString *is_enrol;//否已报名

@end
