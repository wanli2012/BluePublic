//
//  GLPublish_ProjectInProgressCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_FundraisingCell.h"

@interface GLPublish_FundraisingCell ()

@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *progressBgView;
@property (weak, nonatomic) IBOutlet UILabel *persentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@end

@implementation GLPublish_FundraisingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.picImageV.layer.cornerRadius = 5.f;
    
    self.ballView.layer.cornerRadius = self.ballView.height/2;
    self.ballView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.ballView.layer.borderWidth = 1.f;
    
    self.progressViewWidth.constant = self.progressBgView.width * 0.3;
    self.persentLabel.text = @"30%";
    
}


@end
