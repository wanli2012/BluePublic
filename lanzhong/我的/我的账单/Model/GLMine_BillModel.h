//
//  GLMine_BillModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_BillModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *income;
@property (nonatomic, copy)NSString *type;

@end

@interface GLMine_Bill_FilterModel : NSObject

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)BOOL isSelect;

@end
