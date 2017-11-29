//
//  GLPublish_ProjectInProgressCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLPublish_InReViewModel.h"

@protocol GLPublish_FundraisingCellDelegate <NSObject>

@optional
- (void)surportList:(NSInteger)index;

@end

@interface GLPublish_FundraisingCell : UITableViewCell

@property (nonatomic, strong)GLPublish_InReViewModel *model;
@property (weak, nonatomic) IBOutlet UIButton *suportListBtn;
@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLPublish_FundraisingCellDelegate>delegate;

@end
