//
//  GLMineCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/26.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLMineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic, assign)NSInteger status;

@end
