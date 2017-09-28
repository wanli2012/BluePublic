//
//  GLMineCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineCell.h"

@interface GLMineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabeltrailing;

@end

@implementation GLMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setStatus:(NSInteger)status{
    
    if (status == 0) {//文字箭头正常显示
        self.arrowImageV.hidden = NO;
        self.valueLabeltrailing.constant = 30;
        
    }else if(status == 1){//只显示文字,隐藏箭头
        self.arrowImageV.hidden = YES;
        self.valueLabeltrailing.constant = 15;
        
    }else{//只显示箭头
        self.arrowImageV.hidden = NO;
        self.valueLabel.hidden = YES;
    }
}
@end
