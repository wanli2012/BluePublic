//
//  GLMine_EvaluateController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EvaluateController.h"
#import "GLMine_PendingEvaluateController.h"//带评论
#import "GLMine_EvaluatedController.h"//已评论


@interface GLMine_EvaluateController ()

@end

@implementation GLMine_EvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"商品评价";
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self addviewcontrol];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:40])
    {
        self.yFloat = 0;
        
    }
    return self;
}

-(void)addviewcontrol{
    
    NSArray *titleArray = @[@"待评论",
                            @"已评论",
                            ];
    
    NSArray *classNames = @[
                            [GLMine_PendingEvaluateController class],
                            [GLMine_EvaluatedController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
      //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArray.count, 40);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
