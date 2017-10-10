//
//  LBAddrecomdManChooseAreaViewController.h
//  Universialshare
//
//  Created by 四川三君科技有限公司 on 2017/4/28.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GLSimpleSelectionPickerController : UIViewController

@property (nonatomic , copy)void(^returnreslut)(NSInteger selectIndex);
@property (nonatomic, strong)NSString *titlestr;
@property (nonatomic, strong)NSMutableArray *dataSourceArr;

@end
