//
//  GLMine_CV_PlaceHolderCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_CV_PlaceHolderCellDelegate <NSObject>

- (void)edit:(NSInteger)index;

@end

@interface GLMine_CV_PlaceHolderCell : UITableViewCell

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, weak)id <GLMine_CV_PlaceHolderCellDelegate> delegate;

@end
