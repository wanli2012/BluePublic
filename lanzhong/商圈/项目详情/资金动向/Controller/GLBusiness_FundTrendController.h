//
//  GLBusiness_FundTrendController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLBusiness_FundTrendController : UIViewController

@property (nonatomic, copy)NSString *item_id;

@property (nonatomic, assign)NSInteger signIndex;// 1:从我的项目(进行中)跳转过来的 0:从项目详情跳转过来的

@end
