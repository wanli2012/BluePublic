//
//  GLMall_DetailSpecCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMall_DetailSpecCell.h"

@interface GLMall_DetailSpecCell ()

@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation GLMall_DetailSpecCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)changeNum:(UIButton *)sender {
    
    if([self.delegate respondsToSelector:@selector(changeNum:)]){
        if (sender == self.reduceBtn) {
            
            [self.delegate changeNum:NO];
        }else{
            [self.delegate changeNum:YES];
        }
    }
}

@end
