//
//  GLPublish_ReviewCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ReviewCell.h"

@interface GLPublish_ReviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;//蒙版
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//标志iamgeV
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//标志label

@end

@implementation GLPublish_ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    
}

@end
