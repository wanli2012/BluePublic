//
//  GLTrainListCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/12/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLTrainListModel.h"

@protocol GLTrainListCellDelegate <NSObject>

- (void)signUp:(NSInteger)index;

@end

@interface GLTrainListCell : UITableViewCell

@property (nonatomic, strong)GLTrainListModel *model;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, weak)id <GLTrainListCellDelegate> delegate;

@end
