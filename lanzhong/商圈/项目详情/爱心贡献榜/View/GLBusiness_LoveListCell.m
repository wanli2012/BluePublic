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
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankingLabel;

@end

@implementation GLBusiness_LoveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
 
}

- (void)setModel:(GLBusiness_HeartModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.must_user_pic];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.rankingLabel.text = [NSString stringWithFormat:@"%zd",self.index + 4];
    self.nameLabel.text = model.uname;
    
    NSString *str = [NSString stringWithFormat:@"%@",model.money];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",str]];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,str.length)];
    
    self.moneyLabel.attributedText = hintString;

    self.dateLabel.text = [formattime formateTimeOfDate3:model.addtime];
    
}


@end
