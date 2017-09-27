//
//  GLMall_DetailSpecCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMall_DetailSpecCellDelegate <NSObject>

- (void)changeNum:(BOOL)isAdd;

@end

@interface GLMall_DetailSpecCell : UITableViewCell

@property (nonatomic, weak)id <GLMall_DetailSpecCellDelegate>delegate;

@end
