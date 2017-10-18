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


@end
