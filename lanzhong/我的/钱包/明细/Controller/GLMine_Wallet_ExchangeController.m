//
//  GLMine_Wallet_ExchangeController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/16.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Wallet_ExchangeController.h"
#import "GLMine_Wallet_Exchange_SuccessController.h"
#import "GLMine_Wallet_Exchange_FailedController.h"
#import "GLMine_Wallet_Exchange_InReviewController.h"

@interface GLMine_Wallet_ExchangeController ()

@end

@implementation GLMine_Wallet_ExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"兑换记录";
    [self addviewcontrol];
    self.hidesBottomBarWhenPushed=YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

////返回
//- (IBAction)pop:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}


//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:40]){

        self.yFloat = 0;
 
    }
    return self;
}

-(void)addviewcontrol{
    
    NSArray *titleArray = @[@"审核中",
                            @"失败",
                            @"成功"
                            ];
    
    NSArray *classNames = @[
                            [GLMine_Wallet_Exchange_InReviewController class],
                            [GLMine_Wallet_Exchange_FailedController class],
                            [GLMine_Wallet_Exchange_SuccessController class],
                                                        ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);

    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArray.count, 40);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
