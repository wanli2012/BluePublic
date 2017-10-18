//
//  GLMine_EvaluateModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_EvaluateModel : NSObject

@property (nonatomic, copy)NSString *og_id;//订单产品id
@property (nonatomic, copy)NSString *order_id;//订单id
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *goods_id;//商品id
@property (nonatomic, copy)NSString *goods_name;//商品名称
@property (nonatomic, copy)NSString *goods_num;//购买数量
@property (nonatomic, copy)NSString *goods_discount;// 商品单价
@property (nonatomic, copy)NSString *total_price;//购买总价
@property (nonatomic, copy)NSString *is_comment;//是否已评论
@property (nonatomic, copy)NSString *op_id;//规格id
@property (nonatomic, copy)NSString *comment_id;//评论id
@property (nonatomic, copy)NSString *comment;//评论内容
@property (nonatomic, copy)NSString *reply;//回复内容
@property (nonatomic, copy)NSString *addtime;//添评论时间
@property (nonatomic, copy)NSString *reply_time;//回复时间
@property (nonatomic, copy)NSString *title;//规格名称
@property (nonatomic, copy)NSString *must_thumb;//商品展示图

@property (nonatomic, assign)CGFloat cellHeight;//cell高度

@end
