//
//  GLBusiness_DetailModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailModel.h"

@implementation GLBusiness_HeartModel

@end

@implementation GLBusiness_CommentModel

@end

@implementation GLBusiness_DetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"invest_10":@"GLBusiness_HeartModel",
             @"invest_list":@"GLBusiness_CommentModel"
             };
}

@end
