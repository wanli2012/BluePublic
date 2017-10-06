//
//  GLForgetPasswordController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLForgetPasswordController.h"

@interface GLForgetPasswordController ()

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation GLForgetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"忘记密码";
    self.submitBtn.layer.cornerRadius = 5.f;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)getCode:(id)sender {
    
}

@end
