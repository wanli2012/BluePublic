//
//  GLPublish_ProjectCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPublish_InReViewModel.h"

@protocol GLPublish_ProjectCellDelegate <NSObject>

- (void)surportList:(NSInteger)index;
- (void)fundList:(NSInteger)index;

@end

@interface GLPublish_ProjectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;//资金数
@property (weak, nonatomic) IBOutlet UIButton *fundTrendBtn;//资金动向
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//人数Label
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;//箭头

@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;//标志
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//标志label

@property (nonatomic, strong)GLPublish_InReViewModel *model;
@property (weak, nonatomic) IBOutlet UIButton *suportListBtn;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLPublish_ProjectCellDelegate>delegate;

@end
