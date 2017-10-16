//
//  GLMine_BankNameModel.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_BankNameModel.h"

@implementation GLMine_BankNameModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key  {
    if([key isEqualToString:@"id"])
        self.bank_id = value;
}

@end
