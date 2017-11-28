//
//  GLMine_CV_BaseCell.h
//  lanzhong
//
//  Created by 龚磊 on 2017/11/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLMine_CV_DetailModel.h"

@protocol GLMine_CV_BaseCellDelegate <NSObject>
@optional
- (void)callThePerson:(NSString *)phoneNum;

@end

@interface GLMine_CV_BaseCell : UITableViewCell

@property (nonatomic, strong)GLMine_CV_basic *model;

@property (nonatomic, weak)id <GLMine_CV_BaseCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *callBtn;

@end
