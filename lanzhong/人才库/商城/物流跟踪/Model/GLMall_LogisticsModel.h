//
//  GLMall_LogisticsModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMall_list : NSObject

@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *time;

@end

@interface GLMall_LogisticsModel : NSObject

@property (nonatomic, copy)NSString *deliverystatus;
@property (nonatomic, copy)NSString *issign;
@property (nonatomic, copy)NSString *number;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSArray <GLMall_list *>*list;

@end
