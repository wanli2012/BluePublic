//
//  GLBusiness_LoveListCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBusiness_DetailModel.h"

@interface GLBusiness_LoveListCell : UITableViewCell

@property (nonatomic, strong)GLBusiness_HeartModel *model;

@property (nonatomic, assign)NSInteger index;

@end
