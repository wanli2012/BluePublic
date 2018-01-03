//
//  GLMine_TrainModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/12/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_TrainModel : NSObject

@property (nonatomic, copy)NSString *enrol_id;//报名id
@property (nonatomic, copy)NSString *train_id;//培训id
@property (nonatomic, copy)NSString *uid;//uid
@property (nonatomic, copy)NSString *addtime;//报名时间
@property (nonatomic, copy)NSString *train_name;//培训标题
@property (nonatomic, copy)NSString *start_time;//培训开始时间
@property (nonatomic, copy)NSString *end_time;//培训结束时间
@property (nonatomic, copy)NSString *open;//培训是否开启 1开启 2关闭

@end

