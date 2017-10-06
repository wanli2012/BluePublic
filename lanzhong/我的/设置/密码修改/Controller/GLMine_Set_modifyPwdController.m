//
//  GLMine_Set_modifyPwdController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_Set_modifyPwdController.h"

@interface GLMine_Set_modifyPwdController ()

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation GLMine_Set_modifyPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改密码";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ensureBtn.layer.cornerRadius = 5.f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

@end
