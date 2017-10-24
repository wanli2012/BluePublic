//
//  GLMine_MyOrderController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/14.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyOrderController.h"
#import "GLMine_PaidOrderController.h"//已付款
#import "GLMine_CompletedOrderController.h"//已完成
#import "GLMine_PendingPayOrderController.h"//待付款
#import "GLMine_ReceiveController.h"//待收货
#import "GLMine_ReturnGoodsController.h"//退换货

@interface GLMine_MyOrderController ()

@end

@implementation GLMine_MyOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"我的订单";
    
    [self setNav];
    [self addviewcontrol];
    
}
- (void)setNav {
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
//    [rightBtn setTitle:@"退换货" forState:UIControlStateNormal];
//    [rightBtn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
//    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [rightBtn addTarget:self action:@selector(returnGoods) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    [rightBtn setImage:[UIImage imageNamed:@"tui"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);

    rightBtn.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)returnGoods {

    self.hidesBottomBarWhenPushed = YES;
    
    GLMine_ReturnGoodsController *returnVC = [[GLMine_ReturnGoodsController alloc] init];
    [self.navigationController pushViewController:returnVC animated:YES];
    
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
    
    NSArray *titleArray = @[@"已付款",
                            @"已完成",
                            @"待付款",
                            @"待收货",
                            ];
    
    NSArray *classNames = @[
                            [GLMine_PaidOrderController class],
                            [GLMine_CompletedOrderController class],
                            [GLMine_PendingPayOrderController class],
                            [GLMine_ReceiveController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
       //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArray.count, 40);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}

@end
