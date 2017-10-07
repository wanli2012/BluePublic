//
//  BaseNavigationViewController.m
//  PovertyAlleviation
//
//  Created by 四川三君科技有限公司 on 2017/2/20.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:MAIN_COLOR}];

}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [super pushViewController:viewController animated:animated];
    
    [self.visibleViewController.navigationItem setHidesBackButton:YES];
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake( 0, 0, 60, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;//左对齐
    [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0 ,10, 0, 0)];
    // 让返回按钮内容继续向左边偏移10
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 0);
    
    button.backgroundColor=[UIColor clearColor];
    [button addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *ba=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.visibleViewController.navigationItem.leftBarButtonItem = ba;
    
}

- (UIBarButtonItem*)createBackButton{
    
    return [[UIBarButtonItem alloc]
            
            initWithTitle:@"返回"
            
            style:UIBarButtonItemStylePlain
            
            target:self 
            
            action:@selector(popself)];
    
}

-(void)popself
{
    
    [self popViewControllerAnimated:YES];
    
}

@end
