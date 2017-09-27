//
//  GLMall_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailCommentCell.h"

@interface GLMall_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMall_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
    
}


@end
