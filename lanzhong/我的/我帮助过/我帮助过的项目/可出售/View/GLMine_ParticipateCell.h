//
//  GLMine_ParticipateCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/17.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_ParticpateModel.h"

@protocol GLMine_ParticipateCellDelegate <NSObject>

- (void)sell:(NSInteger)index;

@end

@interface GLMine_ParticipateCell : UITableViewCell

@property (nonatomic, strong)GLMine_ParticpateModel *model;

@property (nonatomic, weak)id <GLMine_ParticipateCellDelegate> delegate;

@property (nonatomic, assign)NSInteger index;

@end
