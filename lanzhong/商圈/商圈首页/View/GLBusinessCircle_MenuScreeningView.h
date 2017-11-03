//
//  GLBusinessCircle_MenuScreeningView.h
//  lanzhong
//
//  Created by 龚磊 on 2017/10/9.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MenuScreeningViewBlock)(NSInteger itemIndex,NSInteger firstIndex,NSInteger index2);

@interface GLBusinessCircle_MenuScreeningView : UIView

@property (nonatomic, copy)NSArray *dataArr1;
@property (nonatomic, copy)NSArray *dataArr2;
@property (nonatomic, copy)NSArray *dataArr3;
@property (nonatomic, copy)NSArray *dataArr4;

@property (nonatomic, copy)NSArray *titles;
//@property (nonatomic, assign)BOOL isHaveSecond;//是否有二级选项

@property (nonatomic, copy)MenuScreeningViewBlock block;

- (void)menuScreeningViewDismiss;

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles;


@end
