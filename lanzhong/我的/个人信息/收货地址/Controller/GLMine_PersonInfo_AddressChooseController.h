//
//  GLMine_PersonInfo_AddressChooseController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GLMine_PersonInfo_AddressChooseControllerBlock)(NSString *name,NSString *phoneNum,NSString *address,NSString *addressid);

@interface GLMine_PersonInfo_AddressChooseController : UIViewController

@property (nonatomic, copy)GLMine_PersonInfo_AddressChooseControllerBlock block;

@end
