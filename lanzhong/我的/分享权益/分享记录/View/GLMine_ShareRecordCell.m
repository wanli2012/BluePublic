//
//  GLMine_ShareRecordCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_ShareRecordCell.h"

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
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",model.must_user_pic];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = model.phone;
    self.dateLabel.text = [formattime formateTimeOfDate3:model.addtime];
    
    if (model.truename.length == 0) {
        
        self.trueNameLabel.text = [NSString stringWithFormat:@"真实姓名:暂无"];
    }else{
        self.trueNameLabel.text = [NSString stringWithFormat:@"真实姓名:%@",model.truename];
    }
    
}

@end
