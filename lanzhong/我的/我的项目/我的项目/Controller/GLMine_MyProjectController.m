//
//  GLMine_MyProjectController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/30.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_MyProjectController.h"

#import "GLPublish_InReviewController.h"//审核中
#import "GLPublish_AuditFailureController.h"//审核失败
#import "GLPublish_FundraisingController.h"//筹款中
#import "GLPublish_FundraisingSuccessController.h"//筹款失败
#import "GLPublish_ProjectInProgressController.h"//项目进行中
#import "GLPublish_ProjectPauseController.h"//项目暂停
#import "GLPublish_ProjectCompletedController.h"//项目完成

#import "GLPublish_FundStopController.h"//项目停止
#import "GLPublish_FailedController.h"//项目失败
#import "GLPublish_FundFailedController.h"//筹款失败

@interface GLMine_MyProjectController ()

@property (nonatomic,assign) NSInteger index;

@end

@implementation GLMine_MyProjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.hidesBottomBarWhenPushed=YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    switch (self.signIndex) {
        case 0:
        {
            self.navigationItem.title = @"谁帮助过我";
        }
            break;
        case 1:
        {
            self.navigationItem.title = @"我的审核";
        }
            break;
        case 2:
        {
            self.navigationItem.title = @"我的项目";
        }
            break;
            
        default:
            break;
    }
}

//返回
- (IBAction)pop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//重载init方法
- (instancetype)initWithSignIndex:(NSInteger)index
{
    if (self = [super initWithTagViewHeight:40])
    {
        self.signIndex = index;
        self.yFloat = 0;
        [self addviewcontrol];
    }
    return self;
}

-(void)addviewcontrol{

    NSArray *titleArray = @[@"审核中",
                            @"审核失败",
                            @"筹款中",
                            @"筹款成功",
                            @"筹款暂停",
                            @"筹款失败",
                            @"项目进行中",
                            @"项目暂停",
                            @"项目完成",
                            @"项目失败"
                            ];
    NSArray *classNames = @[
                            [GLPublish_InReviewController class],
                            [GLPublish_AuditFailureController class],
                            [GLPublish_FundraisingController class],
                            [GLPublish_FundraisingSuccessController class],
                            [GLPublish_FundStopController class],
                            [GLPublish_FundFailedController class],
                            [GLPublish_ProjectInProgressController class],
                            [GLPublish_ProjectPauseController class],
                            [GLPublish_ProjectCompletedController class],
                            [GLPublish_FailedController class]
                            ];
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
    NSArray *titleArr;
    NSArray *classNamesArr;

    switch (self.signIndex) {
        case 0:
        {
            titleArr = @[titleArray[2],titleArray[3],titleArray[4],titleArray[5]];
            classNamesArr = @[classNames[2],classNames[3],classNames[4],classNames[5]];
        }
            break;
        case 1:
        {
            titleArr = @[titleArray[0],titleArray[1]];
            classNamesArr = @[classNames[0],classNames[1]];
        }
            break;
        case 2:
        {
            titleArr = @[titleArray[6],titleArray[7],titleArray[8],titleArray[9]];
            classNamesArr = @[classNames[6],classNames[7],classNames[8],classNames[9]];

        }
            break;
        default:
            break;
    }
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / titleArr.count, 40);
    [self reloadDataWith:titleArr andSubViewdisplayClasses:classNamesArr withParams:nil];
}

@end
