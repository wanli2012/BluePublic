//
//  GLBusiness_DetailCommentCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLBusiness_DetailModel.h"

@protocol GLBusiness_DetailCommentCellDelegate <NSObject>

@optional
//- (void)personInfo:(NSInteger)index;
- (void)reply:(NSInteger)index;

@end

@interface GLBusiness_DetailCommentCell : UITableViewCell

@property (nonatomic, strong)GLBusiness_CommentModel *model;

//@property (nonatomic, copy)NSString *replyName;

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLBusiness_DetailCommentCellDelegate>delegate;

@end
