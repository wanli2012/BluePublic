//
//  GLMall_DetailSelecteCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailSelecteCell.h"

@interface GLMall_DetailSelecteCell ()

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;//商品详情
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;//用户评论

@end

@implementation GLMall_DetailSelecteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)goodsDetail:(id)sender {
    
    [self.detailBtn setTitleColor:YYSRGBColor(24, 97, 228, 1) forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(selectedFunc:)]) {
        [self.delegate selectedFunc:YES];
    }
}

- (IBAction)comment:(id)sender {
    
    [self.commentBtn setTitleColor:YYSRGBColor(24, 97, 228, 1) forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(selectedFunc:)]) {
        [self.delegate selectedFunc:NO];
    }
}


@end
