//
//  GLRegisterController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"
#import "GLBusiness_CertificationController.h"

@interface GLRegisterController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//账号,手机号
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *ensurePwdTF;//确认密码
@property (weak, nonatomic) IBOutlet UITextField *codeTF;//验证码

@property (strong, nonatomic)LoadWaitView *loadV;

@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentWidth.constant = kSCREEN_WIDTH;
    self.contentHeight.constant = 570;
    
    self.getCodeBtn.layer.borderWidth = 1.f;
    self.getCodeBtn.layer.borderColor = YYSRGBColor(0, 126, 255, 1).CGColor;
    self.getCodeBtn.layer.cornerRadius = 5.f;
    
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowRadius = 3.f;
    self.bgView.layer.shadowColor = [UIColor blueColor].CGColor;
    
    self.registerBtn.layer.cornerRadius = 5.f;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

//返回
- (IBAction)back:(id)sender {
    NSLog(@"返回");
}

- (IBAction)privacy:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *aboutVC = [[GLBusiness_CertificationController alloc] init];
    aboutVC.url = Register_Protocol_URL;
    aboutVC.navTitle = @"注册协议";
    [self.navigationController pushViewController:aboutVC animated:YES];
}

//注册
- (IBAction)register:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    if (self.passwordTF.text.length <= 0) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {
        [MBProgressHUD showError:@"请输入6-12位密码"];
        return;
    }
    
    if ([predicateModel checkIsHaveNumAndLetter:self.passwordTF.text] != 3) {
        
        [MBProgressHUD showError:@"密码须包含数字和字母"];
        return;
    }
    
    if (self.ensurePwdTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入确认密码"];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.ensurePwdTF.text]) {
        [MBProgressHUD showError:@"两次输入的密码不一致"];
        return;
    }
    
    if (self.codeTF.text.length <= 0) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"phone"] = self.phoneTF.text;
    dict[@"upwd"] = self.passwordTF.text;
    dict[@"phone_code"] = self.codeTF.text;
    dict[@"reg_port"] = @"3";
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kREGISTER_URL paramDic:dict finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [MBProgressHUD showSuccess:@"注册成功"];
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [MBProgressHUD showError:error.localizedDescription];
        
    }];
}

- (IBAction)login:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)getCode:(id)sender {
    
    if (self.phoneTF.text.length <=0 ) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }else{
        if (![predicateModel valiMobile:self.phoneTF.text]) {
            [MBProgressHUD showError:@"手机号格式不对"];
            return;
        }
    }
    
    [self startTime];//获取倒计时
    [NetworkManager requestPOSTWithURLStr:kGETCODE_URL paramDic:@{@"phone":self.phoneTF.text} finish:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
        }else{
            
        }
    } enError:^(NSError *error) {
        
    }];
    
}

//获取倒计时
-(void)startTime{
    
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCodeBtn setTitle:@"  重发验证码  " forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = YES;
                self.getCodeBtn.backgroundColor = [UIColor whiteColor];
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            });
            
        }else{
            
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"  %.2d秒后重新发送  ", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                self.getCodeBtn.userInteractionEnabled = NO;
                self.getCodeBtn.backgroundColor = YYSRGBColor(184, 184, 184, 1);
                self.getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


@end
