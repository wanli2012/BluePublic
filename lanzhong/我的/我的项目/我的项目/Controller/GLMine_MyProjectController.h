//
//  GLMine_MyProjectController.h
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBScrollPageController.h"

@interface GLMine_MyProjectController : XBScrollPageController

//@property (assign, nonatomic)BOOL isSelectindex;//YES 选中待奖励 NO选中已完成

@property (nonatomic, assign)NSInteger signIndex;//标志符

- (instancetype)initWithSignIndex:(NSInteger)index;

@end
