//
//  GLMine_CV_ExpectedJobCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_ExpectedJobCell.h"

@interface GLMine_CV_ExpectedJobCell ()
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation GLMine_CV_ExpectedJobCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setModel:(GLMine_CV_want *)model{
    _model = model;

    self.positionLabel.text = model.want_duty;
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@/%@",model.want_province_name,model.want_city_name,model.want_wages];
}
@end
