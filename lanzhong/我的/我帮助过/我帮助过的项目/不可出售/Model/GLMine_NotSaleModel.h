//
//  GLMine_NotSaleModel.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_NotSaleModel : NSObject

@property (nonatomic, copy)NSString *picName;
@property (nonatomic, copy)NSString *projectName;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, copy)NSString *raise;
@property (nonatomic, copy)NSString *insure;
@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *cost;
@property (nonatomic, copy)NSString *partners;

@property (nonatomic, copy)NSString *status;//0:项目筹款中 1:项目筹款失败 2:项目筹款完成 3:项目进行中 4:项目完成 5:项目暂停 6:项目失败 7:项目结束

@end
