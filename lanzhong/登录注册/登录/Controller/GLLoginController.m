//
//  GLLoginController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLLoginController.h"
#import "GLRegisterController.h"//注册
#import "GLForgetPasswordController.h"//忘记密码

@interface GLLoginController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoImageV.layer.cornerRadius = self.logoImageV.height/2;
//    self.logoImageV.layer.borderColor = [UIColor blueColor].CGColor;
//    self.logoImageV.layer.borderWidth = 1.f;
//    
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowRadius = 3.f;
    self.bgView.layer.shadowColor = [UIColor blueColor].CGColor;
    
    self.ensureBtn.layer.cornerRadius = 5.f;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}
//忘记密码
- (IBAction)forgetPassword:(id)sender {
    NSLog(@"忘记密码");
    GLForgetPasswordController *passVC = [[GLForgetPasswordController alloc] init];
    [self.navigationController pushViewController:passVC animated:YES];
}

//注册
- (IBAction)register:(id)sender {
    
    NSLog(@"注册");
    
    GLRegisterController *registerVC = [[GLRegisterController alloc] init];

    [self.navigationController pushViewController:registerVC animated:YES];
    
}

//登录
- (IBAction)login:(id)sender {
    NSLog(@"登录");
}
- (IBAction)back:(id)sender {
    
    NSLog(@"返回");
    
}

@end
