//
//  GLMine_CV_PlaceHolderCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_PlaceHolderCell.h"

@implementation GLMine_CV_PlaceHolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(edit)];
    [self addGestureRecognizer:tap];
}

- (void)edit{
    if ([self.delegate respondsToSelector:@selector(edit:)]) {
        [self.delegate edit:self.index];
    }
}

@end
