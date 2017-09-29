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

@end

@implementation GLBusiness_LoveListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = self.picImageV.height / 2;
    
    NSString *str = [NSString stringWithFormat:@"%@",@"800"];
    
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",str]];
    
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0,str.length)];
    
    self.moneyLabel.attributedText = hintString;
}


@end
