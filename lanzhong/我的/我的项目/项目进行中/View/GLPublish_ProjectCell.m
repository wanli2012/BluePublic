//
//  GLPublish_ProjectCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_ProjectCell.h"

@interface GLPublish_ProjectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIView *bgView;//蒙版
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//标志label





@end

@implementation GLPublish_ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    self.bgView.layer.cornerRadius = 5.f;
    
    self.arrowImageV.hidden = NO;
    self.fundTrendBtn.hidden = NO;
    
    self.numberLabel.hidden = YES;
    
    NSString *str = [NSString stringWithFormat:@"%@",@"1200人"];
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参与人数 %@",str]];
    // 需要改变的区间
    NSRange range = NSMakeRange(5, str.length);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    // 为label添加Attributed
    [self.numberLabel setAttributedText:noteStr];
    
    NSString *str1 = [NSString stringWithFormat:@"%@",@"1200元"];
    // 创建Attributed
    NSMutableAttributedString *noteStr1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共筹 %@",str1]];
    // 需要改变的区间
    NSRange range1 = NSMakeRange(3, str.length);
    // 改变颜色
    [noteStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
    // 改变字体大小及类型
    [noteStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range1];
    [self.moneyLabel setAttributedText:noteStr1];
}

//资金动向
- (IBAction)fundTrend:(id)sender {
    
    NSLog(@"资金动向");
}


@end
