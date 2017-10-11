//
//  GLBusiness_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLBusiness_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

@end

@implementation GLBusiness_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}
- (void)setModel:(GLBusiness_CommentModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.uname;
    self.priceLabel.text = [NSString stringWithFormat:@"支持了 %@",model.money];
    self.commentLabel.text = model.comment;
}

@end
