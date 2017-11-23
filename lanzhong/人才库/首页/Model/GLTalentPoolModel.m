//
//  GLTalentPoolModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTalentPoolModel.h"

@implementation GLTalentPool_Category : NSObject

@end

@implementation GLTalentPoolModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"money":@"GLTalentPool_Category",
             @"duty":@"GLTalentPool_Category",
             @"work":@"GLTalentPool_Category",
             };
}

@end
