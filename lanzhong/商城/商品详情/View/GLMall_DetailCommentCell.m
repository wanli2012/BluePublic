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

@property (weak, nonatomic) IBOutlet UIView *replyView;//回复View
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end

@implementation GLMall_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}

- (void)setModel:(GLDetail_comment_data *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.must_user_pic];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    self.contentLabel.text = model.comment;
    self.replyLabel.text = [NSString stringWithFormat:@"回复:%@",model.reply];
    
    if (model.nickname.length == 0) {
        
        self.nameLabel.text = model.uname;
        
    }else{
        
        self.nameLabel.text = model.nickname;
    }
    
    if(model.reply.length == 0){
        self.replyView.hidden = YES;
    }else{
        self.replyView.hidden = NO;
    }
    
}

@end
