//
//  GLMine_RicePayModel.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLMine_pay : NSObject

@property (nonatomic, copy)NSString *open;

@end

@interface GLMine_RicePayModel : NSObject

@property (nonatomic, strong)GLMine_pay *credit;
@property (nonatomic, strong)GLMine_pay *alipay;
@property (nonatomic, strong)GLMine_pay *wechat;

@end
