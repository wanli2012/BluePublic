//
//  GLShoppingCartModel.h
//  Universialshare
//
//  Created by 龚磊 on 2017/4/27.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLShoppingCartModel : NSObject

@property (nonatomic, copy)NSString *goods_name;

@property (nonatomic, copy)NSString *goods_id;

@property (nonatomic, copy)NSString *marketprice;

@property (nonatomic, copy)NSString *num;

@property (nonatomic, copy)NSString *must_thumb;

@property (nonatomic, copy)NSString *cart_id;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *goods_info;

@property (nonatomic, copy)NSString *spec_id;
@property (nonatomic, copy)NSString *addtime;
@property (nonatomic, copy)NSString *uid;

@property (nonatomic, assign)BOOL isSelect;//是否被选

@end
