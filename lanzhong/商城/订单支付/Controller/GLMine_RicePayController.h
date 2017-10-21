//
//  GLMine_RicePayController.h
//  Universialshare
//
//  Created by 龚磊 on 2017/8/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GLMine_RicePayControllerBlock)();

@interface GLMine_RicePayController : UIViewController

@property (nonatomic, copy) NSString *order_id;//订单id

@property (nonatomic, copy) NSString *order_sn;//订单号

@property (nonatomic, copy) NSString *orderPrice;//订单金额

@property (nonatomic, assign)NSInteger signIndex;//1:订单支付 我的订单界面跳转过来的   0:下单成功

@property (nonatomic, copy)GLMine_RicePayControllerBlock block;

@end
