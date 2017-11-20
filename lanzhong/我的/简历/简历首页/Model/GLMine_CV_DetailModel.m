//
//  GLMine_CV_DetailModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_DetailModel.h"

@implementation GLMine_CV_basic : NSObject

@end

@implementation GLMine_CV_teach : NSObject


@end
@implementation GLMine_CV_want : NSObject

@end
@implementation GLMine_CV_live : NSObject

@end
@implementation GLMine_CV_skill : NSObject

@end

@implementation GLMine_CV_DetailModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"live":@"GLMine_CV_live",
             @"skill":@"GLMine_CV_skill",
            };
}

@end
