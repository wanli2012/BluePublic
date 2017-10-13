//
//  GLMall_DetailModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/11.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLDetail_GoodsDetail : NSObject

@property (nonatomic, copy)NSString *goods_id;//商品id
@property (nonatomic, copy)NSString *goods_name;//商品名称
@property (nonatomic, copy)NSString *must_thumb;//商品展示图
@property (nonatomic, copy)NSString *cate_id;//分类id
@property (nonatomic, copy)NSString *goods_price;// 原价
@property (nonatomic, copy)NSString *goods_discount;//优惠价
@property (nonatomic, copy)NSString *goods_num;//库存量
@property (nonatomic, copy)NSString *addtime;//上架时间
@property (nonatomic, copy)NSArray *must_thumb_url;//商品多图
@property (nonatomic, copy)NSString *salenum;//已售数量
@property (nonatomic, copy)NSString *goods_info;//商品描述
@property (nonatomic, copy)NSString *goods_details;//商品详情

@end

@interface GLDetail_comment_data : NSObject

@property (nonatomic, copy)NSString *comment_id;//评论id
@property (nonatomic, copy)NSString *uid;//uid
@property (nonatomic, copy)NSString *og_id;//订单商品id
@property (nonatomic, copy)NSString *goods_id;//商品id
@property (nonatomic, copy)NSString *comment;//评论内容
@property (nonatomic, copy)NSString *reply;// 回复内容
@property (nonatomic, copy)NSString *addtime;//评论时间
@property (nonatomic, copy)NSString *reply_time;//回复时间
@property (nonatomic, copy)NSString *uname;//用户名
@property (nonatomic, copy)NSString *must_user_pic;//头像

@end

@interface GLDetail_spec : NSObject

@property (nonatomic, copy)NSString *id;//规格id
@property (nonatomic, copy)NSString *title;// 规格名称
@property (nonatomic, copy)NSString *stock;//商品规格库存量
@property (nonatomic, copy)NSString *marketprice;//销售价格
@property (nonatomic, copy)NSString *productprice;//市场价格
@property (nonatomic, copy)NSString *costprice;// 成本价格
@property (nonatomic, copy)NSString *goodssn;//商品编码
@property (nonatomic, copy)NSString *productsn;//商品条码
@property (nonatomic, copy)NSString *weight;//商品重量
@property (nonatomic, copy)NSString *goodsid;//商品id
@property (nonatomic, copy)NSString *specs;//规格记录

@end

@interface GLMall_DetailModel : NSObject

@property (nonatomic, copy)GLDetail_GoodsDetail *goods_data;//商品信息
//@property (nonatomic, copy)NSString *salenum;//已售数量
//@property (nonatomic, copy)NSString *goods_info;//商品描述
@property (nonatomic, copy)NSString *goods_details;//商品详情
@property (nonatomic, copy)NSString *cart_data;//我都购物车商品数
@property (nonatomic, copy)NSArray<GLDetail_comment_data *> *comment_data;//评论信息
@property (nonatomic, copy)NSArray<GLDetail_spec *> *spec;


@end
