//
//  GLMall_DetailAddressCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailAddressCell.h"

@implementation GLMall_DetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressChoose)];
    [self.contentView addGestureRecognizer:tap];
    
}
- (void)addressChoose {
    
    if ([self.delegate respondsToSelector:@selector(addressChoose)]) {
        [self.delegate addressChoose];
    }
}

@end
