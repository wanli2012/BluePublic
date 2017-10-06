//
//  GLMine_MyMessageController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyMessageController.h"

#import "GLMine_MyMessage_NoticeController.h"//公告
#import "GLMine_MyMessage_ExchangeController.h"//兑换
#import "GLMine_MyMessage_RechargeController.h"//充值
#import "GLMine_MyMessage_DonationController.h"//捐赠
#import "GLMine_MyMessage_SupportController.h"//支持


@interface GLMine_MyMessageController ()

@end

@implementation GLMine_MyMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"我的消息";
    
    [self addviewcontrol];
    
    self.hidesBottomBarWhenPushed=YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//返回
- (IBAction)pop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 5, 40);
    
    NSArray *titleArray = @[
                            @"公告",
                            @"兑换",
                            @"充值",
                            @"捐赠",
                            @"支持"
                            ];
    
    NSArray *classNames = @[
                            [GLMine_MyMessage_NoticeController class],
                            [GLMine_MyMessage_ExchangeController class],
                            [GLMine_MyMessage_RechargeController class],
                            [GLMine_MyMessage_DonationController class],
                            [GLMine_MyMessage_SupportController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}
@end
