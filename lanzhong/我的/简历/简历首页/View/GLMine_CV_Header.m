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
    
    [self addSubview:self.bgImageV];
    [self addSubview:self.titleLabel];
    [self addSubview:self.mustLabel];
    [self addSubview:self.editBtn];
    [self addSubview:self.lineView];
    
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self).offset(0);
        make.leading.equalTo(self).offset(10);
        make.height.equalTo(@25);
        make.width.equalTo(@78);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
 
        make.centerY.equalTo(self).offset(0);
        make.height.equalTo(@25);
        make.leading.equalTo(self).offset(15);
        make.width.equalTo(@80);
    }];
    [self.mustLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self).offset(0);
        make.height.equalTo(@25);
        make.leading.equalTo(self.bgImageV.mas_trailing).offset(5);
        make.width.equalTo(@80);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(self).offset(0);
        make.height.equalTo(@25);
        make.trailing.equalTo(self).offset(10);
        make.width.equalTo(@80);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.equalTo(self).offset(0);
        make.leading.equalTo(self.bgImageV.mas_trailing).offset(-8);
        make.bottom.equalTo(self.bgImageV.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
    }];

}

-(void)edit{
    if (self.block) {
        self.block(self.index);
    }
}

#pragma mark - 懒加载
- (UIImageView *)bgImageV{
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] init];
        _bgImageV.image = [UIImage imageNamed:@"矩形19拷贝"];
        
    }
    return _bgImageV;
}

-(UILabel*)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        
    }
    return _titleLabel;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_editBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_editBtn setTitleColor:YYSRGBColor(22, 131, 251, 1) forState:UIControlStateNormal];
        
    }
    return _editBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = YYSRGBColor(22, 131, 251, 1);
        
    }
    return _lineView;
}

- (UILabel *)mustLabel{
    if (!_mustLabel) {
        _mustLabel = [[UILabel alloc] init];
        _mustLabel.backgroundColor = [UIColor clearColor];
        _mustLabel.textColor = [UIColor redColor];
        _mustLabel.font = [UIFont systemFontOfSize:13];
        _mustLabel.text = @"(*必填)";
        _mustLabel.hidden = YES;
    }
    return _mustLabel;
}

@end
