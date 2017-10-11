//
//  GLMall_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailCommentCell.h"
#import "formattime.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMall_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation GLMall_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}

- (void)setModel:(GLDetail_comment_data *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    self.nameLabel.text = model.uname;
    self.contentLabel.text = model.comment;
    
}

@end
