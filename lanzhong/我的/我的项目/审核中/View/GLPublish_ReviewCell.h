//
//  GLPublish_ReviewCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPublish_InReViewModel.h"
#import "GLPay_CompletedModel.h"

@interface GLPublish_ReviewCell : UITableViewCell

@property (nonatomic, strong)GLPublish_InReViewModel *model;
@property (nonatomic, strong)GLPay_CompletedModel *payModel;

@property (weak, nonatomic) IBOutlet UIView *bgView;//蒙版
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;//标志iamgeV
@property (weak, nonatomic) IBOutlet UILabel *signLabel;//标志label
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//价格

//@property (nonatomic, assign)BOOL isReviewed;//是否在审核中

@end
