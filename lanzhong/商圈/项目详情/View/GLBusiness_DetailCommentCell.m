//
//  GLBusiness_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailCommentCell.h"

@interface GLBusiness_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@end

@implementation GLBusiness_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}


@end
