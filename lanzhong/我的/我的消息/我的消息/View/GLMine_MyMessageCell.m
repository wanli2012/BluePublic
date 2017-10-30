//
//  GLMine_MyMessageCell.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyMessageCell.h"
#import "formattime.h"

@interface GLMine_MyMessageCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation GLMine_MyMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkProject)];
    [self.checkOutView addGestureRecognizer:tap];
    
    self.bgView.layer.cornerRadius = 5.f;
    
}

- (void)checkProject {

    if([self.delegate respondsToSelector:@selector(checkProjectDetail:)]){
        [self.delegate checkProjectDetail:self.index];
    }
}

- (void)setModel:(GLMine_MyMessageModel *)model{
    _model = model;
    self.contentLabel.text = model.log;
    self.dateLabel.text = [formattime formateTimeOfDate3:model.addtime];
    
}

- (void)setNoticeModel:(GLMine_NoticeModel *)noticeModel{
    _noticeModel = noticeModel;
    self.contentLabel.text = noticeModel.title;
    self.dateLabel.text = noticeModel.addtime;
}

@end
