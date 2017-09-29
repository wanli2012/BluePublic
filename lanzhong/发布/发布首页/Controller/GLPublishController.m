//
//  GLPublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublishController.h"

#import "GLPublish_InReviewController.h"//审核中
#import "GLPublish_AuditedController.h"//审核成功
#import "GLPublish_AuditFailureController.h"//审核失败
#import "GLPublish_FundraisingController.h"//筹款中
#import "GLPublish_FundraisingSuccessController.h"//筹款失败
#import "GLPublish_ProjectInProgressController.h"//项目进行中
#import "GLPublish_ProjectPauseController.h"//项目暂停
#import "GLPublish_ProjectCompletedController.h"//项目完成

@interface GLPublishController ()

@property (nonatomic,assign) NSInteger index;

@end

@implementation GLPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addviewcontrol];

    self.hidesBottomBarWhenPushed=YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
        self.yFloat = 64;
    }
    return self;
}


-(void)addviewcontrol{
    
    //设置自定义属性
    self.tagItemSize = CGSizeMake(kSCREEN_WIDTH / 4.5, 40);
    
    NSArray *titleArray = @[
                            @"审核中",
                            @"审核成功",
                            @"审核失败",
                            @"筹款中",
                            @"筹款成功",
                            @"项目进行中",
                            @"项目暂停",
                            @"项目完成",
                            ];
    
    NSArray *classNames = @[
                            [GLPublish_InReviewController class],
                            [GLPublish_AuditedController class],
                            [GLPublish_AuditFailureController class],
                            [GLPublish_FundraisingController class],
                            [GLPublish_FundraisingSuccessController class],
                            [GLPublish_ProjectInProgressController class],
                            [GLPublish_ProjectPauseController class],
                            [GLPublish_ProjectCompletedController class],
                            ];
    
    self.normalTitleColor = [UIColor darkGrayColor];
    self.selectedTitleColor = YYSRGBColor(0, 126, 255, 1);
    self.selectedIndicatorColor = YYSRGBColor(0, 126, 255, 1);
    
    [self reloadDataWith:titleArray andSubViewdisplayClasses:classNames withParams:nil];
    
}


@end
