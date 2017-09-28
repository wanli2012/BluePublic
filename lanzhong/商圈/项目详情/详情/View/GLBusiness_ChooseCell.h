//
//  GLBusiness_ChooseCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLBusiness_ChooseCellDelegate <NSObject>

- (void)didSeletedIndex:(NSInteger)index;

@end

@interface GLBusiness_ChooseCell : UITableViewCell

@property (nonatomic, weak)id <GLBusiness_ChooseCellDelegate> delegate;

@end
