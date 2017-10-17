//
//  GLMine_Wallet_ExchangeModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Wallet_ExchangeModel.h"

@implementation GLMine_Wallet_ExchangeModel

- (CGFloat)cellHeight{
    
    CGRect rect = [self.reason boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];

    
    return 60 + rect.size.height;
}
@end
