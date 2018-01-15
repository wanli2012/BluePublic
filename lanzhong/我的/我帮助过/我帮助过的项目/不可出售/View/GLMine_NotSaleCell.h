//
//  GLMine_NotSaleCell.h
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_NotSaleModel.h"

@protocol GLMine_NotSaleCellDelegate <NSObject>

- (void)moneyDetail:(NSInteger)index;

@end

@interface GLMine_NotSaleCell : UITableViewCell

@property (nonatomic, strong)GLMine_NotSaleModel *model;

@property (nonatomic, weak)id <GLMine_NotSaleCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
