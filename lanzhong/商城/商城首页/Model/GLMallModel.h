//
//  GLMallModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLmall_goods_detailsModel : NSObject 

@property (nonatomic, copy)NSString *cate_id;
@property (nonatomic, copy)NSString *catename;

@end

@interface GLmall_guess_goodsModel : NSObject 

@property (nonatomic, copy)NSString *goods_id;
@property (nonatomic, copy)NSString *goods_name;
@property (nonatomic, copy)NSString *must_thumb;
@property (nonatomic, copy)NSString *cate_id;
@property (nonatomic, copy)NSString *goods_discount;
@property (nonatomic, copy)NSString *goods_num;
@property (nonatomic, copy)NSString *addtime;
@property (nonatomic, copy)NSString *salenum;

@end

@interface GLMallModel : NSObject

@property (nonatomic, copy)NSArray <GLmall_goods_detailsModel *>* goods_details;
@property (nonatomic, copy)NSArray <GLmall_guess_goodsModel *>* guess_goods;

@end
