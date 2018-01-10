//
//  GLMine_SellListController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/10.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SellListController.h"
#import "GLMine_ParticipateController.h"
#import "GLMine_NotSaleController.h"
#import "GLMine_ForSaleController.h"

#import "GLMine_SaleRecordController.h"//出售记录
#import "GLMine_SalePublishController.h"//出售发布
#import "GLBusiness_DetailForSaleController.h"//可卖的项目详情


@interface GLMine_SellListController ()

@end

@implementation GLMine_SellListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBottomBarWhenPushed=YES;
    
    [self setNav];
}

/**
 设置导航栏 title以及右键
 */
- (void)setNav{
    
    self.navigationItem.title = @"我帮助过";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//右对齐
    
    [button setTitle:@"出售记录" forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(saleRecord) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}
/**
 出售记录
 */
- (void)saleRecord {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_SaleRecordController *saleRecordVC = [[GLMine_SaleRecordController alloc] init];
    [self.navigationController pushViewController:saleRecordVC animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    switch (self.signIndex) {
//        case 0:
//        {
            self.navigationItem.title = @"谁帮助过我";
//        }
//            break;
//        case 1:
//        {
//            self.navigationItem.title = @"我的审核";
//        }
//            break;
//        case 2:
//        {
//            self.navigationItem.title = @"我的项目";
//        }
//            break;
//
//        default:
//            break;
//    }
}


//重载init方法
- (instancetype)init
{
    if (self = [super initWithTagViewHeight:40])
    {
        
        self.yFloat = 0;
        [self addviewcontrol];
    }
    return self;
}

-(void)addviewcontrol{
    
    NSArray *titleArray = @[@"可出售",
                            @"售卖中",
                            @"不可出售",
                            ];
    
    NSArray *classNames = @[
                            [GLMine_ParticipateController class],
                            [GLMine_ForSaleController class],
                            [GLMine_NotSaleController class]
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
    NSArray *titleArr = titleArray;
    NSArray *classNamesArr = classNames;
    
//    switch (self.signIndex) {
//        case 0:
//        {
//            titleArr = @[titleArray[2],titleArray[3],titleArray[4],titleArray[5]];
//            classNamesArr = @[classNames[2],classNames[3],classNames[4],classNames[5]];
//        }
//            break;
//        case 1:
//        {
//            titleArr = @[titleArray[0],titleArray[1]];
//            classNamesArr = @[classNames[0],classNames[1]];
//        }
//            break;
//        case 2:
//        {
//            titleArr = @[titleArray[6],titleArray[7],titleArray[8],titleArray[9]];
//            classNamesArr = @[classNames[6],classNames[7],classNames[8],classNames[9]];
//
//        }
//            break;
//        default:
//            break;
//    }
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArr.count, 40);
    [self reloadDataWith:titleArr andSubViewdisplayClasses:classNamesArr withParams:nil];
}


@end
