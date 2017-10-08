//
//  GLBusinessCircleModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/8.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusinessCircleModel.h"

@implementation GLCircle_itemScreen_manModel

@end

@implementation GLCircle_item_screenModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"man":@"GLCircle_itemScreen_manModel",
             @"stop":@"GLCircle_itemScreen_manModel",
             @"trade":@"GLCircle_itemScreen_manModel",
             };
}

@end

@implementation GLCircle_item_dataModel

@end

@implementation GLBusinessCircleModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"item_data":@"GLCircle_item_dataModel"};
}

@end
