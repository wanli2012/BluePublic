//
//  GLMine_BillCollectionCell.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_BillCollectionCell.h"

@interface GLMine_BillCollectionCell()

@property (weak, nonatomic) IBOutlet UIButton *itemBtn;

@end

@implementation GLMine_BillCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.itemBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.itemBtn.layer.borderWidth = 1.f;
    self.itemBtn.layer.cornerRadius = 5.f;
    
}

- (void)setModel:(GLMine_Bill_FilterModel *)model{
    _model = model;
    
    [self.itemBtn setTitle:model.name forState:UIControlStateNormal];
    
    if(model.isSelect){
        
        [self.itemBtn setBackgroundColor:MAIN_COLOR];
        [self.itemBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        [self.itemBtn setBackgroundColor:[UIColor whiteColor]];
        [self.itemBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }
    
}
@end
