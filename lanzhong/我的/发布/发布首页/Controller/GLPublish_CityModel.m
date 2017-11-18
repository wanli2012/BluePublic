//
//  GLPublish_CityModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/3.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_CityModel.h"

@implementation GLPublish_Country

@end

@implementation GLPublish_City

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"country":@"GLPublish_Country"};
}

@end

@implementation GLPublish_CityModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"city":@"GLPublish_City"};
}

@end
