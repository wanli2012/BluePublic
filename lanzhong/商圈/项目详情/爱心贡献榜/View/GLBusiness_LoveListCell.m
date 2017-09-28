//
//  GLBusiness_LoveListCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_LoveListCell.h"

@interface GLBusiness_LoveListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@end

@implementation GLBusiness_LoveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
}


@end
