//
//  GLPublish_CityModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/3.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLPublish_Country: NSObject

@property (nonatomic, copy)NSString *country_name;
@property (nonatomic, copy)NSString *country_code;

@end

@interface GLPublish_City : NSObject

@property (nonatomic, copy)NSString *city_name;
@property (nonatomic, copy)NSString *city_code;
@property (nonatomic, copy)NSArray <GLPublish_Country *>*country;

@end

@interface GLPublish_CityModel : NSObject

@property (nonatomic, copy)NSString *province_name;
@property (nonatomic, copy)NSString *province_code;
@property (nonatomic, copy)NSMutableArray <GLPublish_City *> *city;

@end
