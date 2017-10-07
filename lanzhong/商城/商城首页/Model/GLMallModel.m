//
//  GLMallModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMallModel.h"

@implementation GLmall_goods_detailsModel

@end
@implementation GLmall_guess_goodsModel

@end

@implementation GLMallModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"goods_details":@"GLmall_goods_detailsModel",
             @"guess_goods":@"GLmall_guess_goodsModel"};
}

@end
