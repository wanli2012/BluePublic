//
//  GLPublishCategoryModel.h
//  lanzhong
//
//  Created by 张涵博 on 2018/3/28.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLPublishCategoryModel : NSObject

@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *type_name;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSArray <GLPublishCategoryModel *>*son;

@end
