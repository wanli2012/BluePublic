//
//  GLMineController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"

@interface GLMineController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *bgimageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageV.layer.cornerRadius = self.imageV.height/2;

    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //毛玻璃视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    
    visualEffectView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, 150);
    
    visualEffectView.alpha = 0.9;
    
    [self.bgimageV addSubview:visualEffectView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

@end
