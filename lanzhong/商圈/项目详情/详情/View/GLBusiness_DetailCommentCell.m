//
//  GLBusiness_DetailCommentCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailCommentCell.h"
#import "LWLabel.h"

@interface GLBusiness_DetailCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet LWLabel *replyCommentLabel;//回复
@property (weak, nonatomic) IBOutlet UIView *replyView;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@end

@implementation GLBusiness_DetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    self.replyBtn.layer.cornerRadius = 3.f;
    
}
- (IBAction)reply:(id)sender {
    if ([self.delegate respondsToSelector:@selector(reply:)]) {
        [self.delegate reply:self.index];
    }
}

- (void)setModel:(GLBusiness_CommentModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.must_user_pic];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.priceLabel.text = [NSString stringWithFormat:@"支持了¥ %@",model.money];
    self.commentLabel.text = model.comment;
    self.dateLabel.text = [formattime formateTimeOfDate:model.addtime];
    
    if (model.nickname.length == 0) {
        self.nameLabel.text = model.uname;
    }else{
        self.nameLabel.text = model.nickname;
    }
    
//    typeof(self)weakSelf = self;

    if (model.reply.length == 0) {
        self.replyCommentLabel.height = 0;
        self.replyView.height = 0;
        self.replyView.hidden = YES;
        
        if (model.signIndex == 1) {
            self.replyBtn.hidden = NO;
        }else{
            self.replyBtn.hidden = YES;
        }

    }else{
        
        self.replyView.hidden = NO;
        self.replyBtn.hidden = YES;

    }
    
    NSString *str = [NSString stringWithFormat:@"%@:%@",model.linkman,model.reply];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange redRange = NSMakeRange(0, model.linkman.length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:redRange];
    
    self.replyCommentLabel.rangeArr=(id)@[NSStringFromRange(NSMakeRange(0, model.linkman.length))];
    self.replyCommentLabel.attributedText = noteStr;
    
}

@end
