//
//  GLMine_CV_DescriptionCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_DescriptionCell.h"

@interface GLMine_CV_DescriptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GLMine_CV_DescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setI_info:(NSString *)i_info{
    _i_info = i_info;
    self.titleLabel.text = i_info;
}

@end
