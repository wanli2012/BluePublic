//
//  GLBusiness_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailCommentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"
#import "LWLabel.h"

@interface GLBusiness_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet LWLabel *replyCommentLabel;//回复
@property (weak, nonatomic) IBOutlet UIView *replyView;

@end

@implementation GLBusiness_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
}

- (void)setModel:(GLBusiness_CommentModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.uname;
    self.priceLabel.text = [NSString stringWithFormat:@"支持了 %@",model.money];
    self.commentLabel.text = model.comment;
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    
    typeof(self)weakSelf = self;

    if (model.reply.length == 0) {
        self.replyCommentLabel.height = 0;
        self.replyView.height = 0;
        self.replyView.hidden = YES;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@:%@",model.linkman,model.reply];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange redRange = NSMakeRange(0, model.linkman.length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
    
    self.replyCommentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.linkman.length))];
    self.replyCommentLabel.attributedText = noteStr;
    
    self.replyCommentLabel.selectBlobk = ^(NSString *str,NSRange range,NSInteger index){
    
        if ([weakSelf.delegate respondsToSelector:@selector(personInfo)]) {
            
            [weakSelf.delegate personInfo];
            
        }

    };
    

}

@end
