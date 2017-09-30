//
//  GLHomeCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLHomeCell.h"

@interface GLHomeCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation GLHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.clipsToBounds = YES;
    
}


@end
