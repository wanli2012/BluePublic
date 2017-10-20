//
//  GLPay_CompletedModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLPay_CompletedModel : NSObject

@property (nonatomic, copy)NSString *item_id;//项目id
@property (nonatomic, copy)NSString *title;//项目标题
@property (nonatomic, copy)NSString *info;//项目描述
@property (nonatomic, copy)NSString *sev_photo;//展示图
@property (nonatomic, copy)NSString *invest_count;//参与统计

@end
