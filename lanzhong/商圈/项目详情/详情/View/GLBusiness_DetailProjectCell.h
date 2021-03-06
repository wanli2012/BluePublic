//
//  GLBusiness_DetailProjectCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/27.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLBusiness_DetailProjectCellDelegate <NSObject>

- (void)clickToCheckBigImage:(NSInteger)index;

@end

@interface GLBusiness_DetailProjectCell : UITableViewCell

//@property (nonatomic, copy)NSString *detailStr;
@property (nonatomic, strong)NSArray *dataSourceArr;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak)id <GLBusiness_DetailProjectCellDelegate> delegate;

@end
