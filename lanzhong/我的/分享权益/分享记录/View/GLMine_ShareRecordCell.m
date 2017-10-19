//
//  GLMine_ShareRecordCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ShareRecordCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "formattime.h"

@interface GLMine_ShareRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLMine_ShareRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
}

- (void)setModel:(GLMine_ShareModel *)model{
    _model = model;
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:model.must_user_pic] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.phone;
    self.trueNameLabel.text = model.truename;
    self.dateLabel.text = [formattime formateTimeOfDate3:model.addtime];
    
}

@end
