//
//  GLMall_DetailSelecteCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMall_DetailSelecteCellDelegate  <NSObject>

- (void)selectedFunc:(BOOL)isDetail;

@end

@interface GLMall_DetailSelecteCell : UITableViewCell

@property (nonatomic, weak)id <GLMall_DetailSelecteCellDelegate> delegate;

@end
