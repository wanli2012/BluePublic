//
//  GLBusiness_FundTrendCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBusiness_FundTrendModel.h"
#import "GLMall_LogisticsModel.h"

@interface GLBusiness_FundTrendCell : UITableViewCell

@property (nonatomic, strong)GLBusiness_FundTrendModel *model;
@property (nonatomic, strong)GLMall_list *logisticsmodel;

@property (weak, nonatomic) IBOutlet UIImageView *topImageV;
@property (weak, nonatomic) IBOutlet UIImageView *middleImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageV;

@end
