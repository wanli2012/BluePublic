//
//  GLMine_PendingEvaluateCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_EvaluateModel.h"

@protocol GLMine_PendingEvaluateCellDelegate <NSObject>

- (void)goToEvaluate:(NSInteger)index;

@end

@interface GLMine_PendingEvaluateCell : UITableViewCell

@property (nonatomic, strong)GLMine_EvaluateModel *model;

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id<GLMine_PendingEvaluateCellDelegate> delegate;

@end
