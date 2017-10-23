//
//  LBMyOrdersModel.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

//我的订单模型

@interface LBMyOrdersListModel : NSObject

@property (copy, nonatomic)NSString *goods_id;// 商品id
@property (copy, nonatomic)NSString *goods_name;//商品名称
@property (copy, nonatomic)NSString *goods_num;//数量
@property (copy, nonatomic)NSString *goods_discount;//商品价格
@property (copy, nonatomic)NSString *must_thumb;//商品展示图
@property (copy, nonatomic)NSString *is_comment;//是否评论  1是  0否
@property (copy, nonatomic)NSString *og_id;//订单商品id
@property (copy, nonatomic)NSString *op_id;//规格id
@property (copy, nonatomic)NSString *title;//规格名称
@property (copy, nonatomic)NSString *total_price;//商品总价refunds_state
@property (copy, nonatomic)NSString *refunds_state;//退货状态  0无申请  1申请退货  2管理员同意  3管理员拒绝  4用户已提交退货信息   5管理员审核确定退货退款操作

@end

@interface LBMyOrdersModel : NSObject

@property (assign, nonatomic)BOOL isExpanded;//是否展开

@property (copy, nonatomic)NSString *order_id;//订单id
@property (copy, nonatomic)NSString *uid;//uid
@property (copy, nonatomic)NSString *shop_id;// 商家id
@property (copy, nonatomic)NSString *address_id;//收货地址id
@property (copy, nonatomic)NSString *order_num;//订单号
@property (copy, nonatomic)NSString *order_money;//订单金额
@property (copy, nonatomic)NSString *pay_money;//付款金额
@property (copy, nonatomic)NSString *addtime;//下单时间
@property (copy, nonatomic)NSString *total;//购 买数量
@property (copy, nonatomic)NSString *paytype;// 0未选择支付方式 1支付宝  2微信   3积分
@property (copy, nonatomic)NSString *order_send;//运费
@property (copy, nonatomic)NSString *order_remark;//订单备注
@property (copy, nonatomic)NSString *order_status;//订单状态(0订单异常1 已下单,未付款2 已付款,待发货3 已发货,待验收4 已验收,订单完成5 交易失败6取消订单
@property (copy, nonatomic)NSString *is_del;//是否删除  1是   0否
@property (copy, nonatomic)NSString *is_pay;// 是否支付  0否1是
@property (copy, nonatomic)NSString *is_send;//是否发货  0否1是
@property (copy, nonatomic)NSString *send_num;//快递单号
@property (copy, nonatomic)NSArray <LBMyOrdersListModel *>*order_goods;//订单商品信息

@property (nonatomic, assign)NSInteger section;


@end
