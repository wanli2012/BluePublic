//
//  GLMine_PendingEvaluateCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PendingEvaluateCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLMine_PendingEvaluateCell()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIView *replyLineView;


@end

@implementation GLMine_PendingEvaluateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.evaluateBtn.layer.cornerRadius = 5.f;
    self.picImageV.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLMine_EvaluateModel *)model{
    _model = model;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.must_thumb] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.goods_name;
    self.detailLabel.text = [NSString stringWithFormat:@"规格:%@",model.title];
    self.replyLabel.text = [NSString stringWithFormat:@"商家回复:%@", model.reply];
    self.commentLabel.text = model.comment;
    
    if (model.reply.length == 0) {
        
        self.replyLabel.hidden = YES;
        self.replyLineView.hidden = YES;
        
        CGRect commentRect = [model.comment boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
        
        self.commentView.height = commentRect.size.height + 40;
        
    }else{
        self.replyLabel.hidden = NO;
        self.replyLineView.hidden = NO;

    }

}

- (IBAction)evaluate:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(goToEvaluate:)]){
        [self.delegate goToEvaluate:self.index];
    }
}

@end
