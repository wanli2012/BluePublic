//
//  GLTalentPoolCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/22.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTalentPoolCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface GLTalentPoolCell ()
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearsLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;

@end

@implementation GLTalentPoolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    
}

- (void)setModel:(GLTalent_CVModel *)model{
    _model = model;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100",model.head_pic];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    if (self.picImageV.image == nil) {
        self.picImageV.image = [UIImage imageNamed:PlaceHolderImage];
    }

    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.head_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.nameLabel.text = model.name;
    self.educationLabel.text = model.education;
    self.moneyLabel.text = model.want_wages;
    self.jobLabel.text = model.duty;
    
    if ([model.sex integerValue] == 1) {
        self.sexLabel.text = @"男";
    }else{
        self.sexLabel.text = @"女";
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *birthDay = [dateFormatter dateFromString:model.birth_time];

    self.yearsLabel.text = [NSString stringWithFormat:@"%@岁",[self dateToOld:birthDay]];
}

-(NSString *)dateToOld:(NSDate *)bornDate{
    //获得当前系统时间
    NSDate *currentDate = [NSDate date];
    //获得当前系统时间与出生日期之间的时间间隔
    NSTimeInterval time = [currentDate timeIntervalSinceDate:bornDate];
    //时间间隔以秒作为单位,求年的话除以60*60*24*356
    int age = ((int)time)/(3600*24*365);
    return [NSString stringWithFormat:@"%d",age];
}

@end
