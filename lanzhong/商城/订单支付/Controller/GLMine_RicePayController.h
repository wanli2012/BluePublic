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

@property (nonatomic, copy) NSString *orders_Price;//多订单金额

@property (nonatomic, assign)NSInteger signIndex;//1:订单支付 我的订单界面跳转过来的   下单成功 2:商品立即购买 购物车单商品购买 0:购物车多商品购买

@property (nonatomic, copy)GLMine_RicePayControllerBlock block;

@end
