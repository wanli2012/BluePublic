//
//  GLMine_MyMessageCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_MyMessageModel.h"
#import "GLMine_NoticeModel.h"

@protocol GLMine_MyMessageCellDelegate <NSObject>

- (void)checkProjectDetail:(NSInteger)index;

@end

@interface GLMine_MyMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *checkOutView;

@property (nonatomic, strong)GLMine_MyMessageModel *model;//消息

@property (nonatomic, strong)GLMine_NoticeModel *noticeModel;//公告

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLMine_MyMessageCellDelegate> delegate;

@end
