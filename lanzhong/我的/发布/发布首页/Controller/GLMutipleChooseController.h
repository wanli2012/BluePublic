//
//  GLMutipleChooseController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/3.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPublish_CityModel.h"

@interface GLMutipleChooseController : UIViewController

@property (nonatomic , copy)void(^returnreslut)(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid);
//省市区
@property (nonatomic, strong)NSArray <GLPublish_CityModel *>*dataArr;
@property (nonatomic, strong)NSArray <GLPublish_City *>*cityArr;

@end
