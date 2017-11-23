//
//  GLMine_CV_StyleCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMine_CV_StyleCellDelegate <NSObject>
@optional

- (void)toSeeBigPic:(NSInteger)index;

@end

@interface GLMine_CV_StyleCell : UITableViewCell

@property (nonatomic, copy)NSArray *images;

@property (nonatomic, weak)id <GLMine_CV_StyleCellDelegate>delegate;

@end
