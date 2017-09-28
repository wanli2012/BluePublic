//
//  GLBusiness_ChooseCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_ChooseCell.h"

@interface GLBusiness_ChooseCell ()
@property (weak, nonatomic) IBOutlet UIView *certificationView;//官方认证
@property (weak, nonatomic) IBOutlet UIView *fundingTrendsView;//资金动向


@end

@implementation GLBusiness_ChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)];
    UITapGestureRecognizer *tap2  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose:)];
    [self.certificationView addGestureRecognizer:tap];
    [self.fundingTrendsView addGestureRecognizer:tap2];
}
- (void)choose:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(didSeletedIndex:)]) {
        [self.delegate didSeletedIndex:tap.view.tag];
    }
}

@end
