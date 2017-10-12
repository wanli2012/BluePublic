//
//  GLBusiness_FundTrendModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/12.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLBusiness_FundTrendModel : NSObject

@property (nonatomic, copy)NSString *id;//动向id
@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *uid;//项目人id
@property (nonatomic, copy)NSString *content;//动向内容
@property (nonatomic, copy)NSString *starttime;//开始时间
@property (nonatomic, copy)NSString *endtime;//结束时间
@property (nonatomic, copy)NSString *addtime;//添加时间

@end
