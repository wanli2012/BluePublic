//
//  GLMine_CV_Header.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_Header.h"
#import <Masonry/Masonry.h>

@implementation GLMine_CV_Header

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self initerface];
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    return self;
}

-(void)initerface{

    [self.editBtn addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.editBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.leading.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@80);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.trailing.equalTo(self).offset(10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);
        make.width.equalTo(@80);
    }];

}

-(void)edit{
    if (self.block) {
        self.block(self.index);
    }
}

#pragma mark - 懒加载

-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLabel;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    }
    return _editBtn;
}

@end
