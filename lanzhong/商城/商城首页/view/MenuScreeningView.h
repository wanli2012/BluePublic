//
//  MenuScreeningView.h
//  LinkageMenu
//
//  Created by mango on 2017/3/4.
//  Copyright © 2017年 mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuScreeningView : UIView

@property (nonatomic, copy)NSArray *dataArr1;
@property (nonatomic, copy)NSArray *dataArr2;
@property (nonatomic, copy)NSArray *dataArr3;

-(void)menuScreeningViewDismiss;

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles;

@end
