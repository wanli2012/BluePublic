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
    
    NSString *reason = [NSString stringWithFormat:@"原因:%@",self.reason];
    CGRect rect = [reason boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];

    if ([self.back_status integerValue] == 0) {
        return 70 + rect.size.height;
    }else{
        return 60;
    }
    
}
@end
