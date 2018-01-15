//
//  DropMenuView.h
//  LinkageMenu
//
//  Created by mango on 2017/3/4.
//  Copyright © 2017年 mango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropMenuView;
@protocol DropMenuViewDelegate <NSObject>

@optional
-(void)dropMenuView:(DropMenuView *)view didSelectName:(NSString *)str firstSelectIndex:(NSInteger)firstSelectIndex selectIndex:(NSInteger)selectIndex;

@end



@interface DropMenuView : UIView

@property (nonatomic, weak) id<DropMenuViewDelegate> delegate;

/** 箭头变化 */
@property (nonatomic, strong) UIView *arrowView;


/**
  控件设置

 @param view 提供控件 位置信息
 @param tableNum 显示TableView数量
 @param arr 使用数据
 */
-(void)creatDropView:(UIView *)view withShowTableNum:(NSInteger)tableNum withData:(NSArray *)arr;

//-(void)creatDropView:(UIView *)view withShowTableNum:(NSInteger)tableNum withData:(NSArray *)arr x:(CGFloat)x width:(CGFloat)width;

/** 视图消失 */
- (void)dismiss;


@end
