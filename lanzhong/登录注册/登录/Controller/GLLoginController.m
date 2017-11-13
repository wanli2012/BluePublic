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
#import "RSAEncryptor.h"

@interface GLLoginController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageV;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (strong, nonatomic)LoadWaitView *loadV;

@property (weak, nonatomic) IBOutlet UILabel *serviceNumLabel;//客服电话Label

@end

@implementation GLLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoImageV.layer.cornerRadius = self.logoImageV.height/2;
    
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

    GLForgetPasswordController *passVC = [[GLForgetPasswordController alloc] init];
    [self.navigationController pushViewController:passVC animated:YES];
}

//注册
- (IBAction)register:(id)sender {
    
    GLRegisterController *registerVC = [[GLRegisterController alloc] init];

    [self.navigationController pushViewController:registerVC animated:YES];
    
}

//登录
- (IBAction)login:(id)sender {
   
    [self.view endEditing:YES];
    if (self.accountTF.text.length <=0 ) {

        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return;
    }
    
    if (self.passwordTF.text.length <= 0) {

        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 12) {

        [SVProgressHUD showErrorWithStatus:@"请输入6-12位密码"];
        return;
    }
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTF.text publicKey:public_RSA];
    
    [NetworkManager requestPOSTWithURLStr:kLOGIN_URL paramDic:@{@"uname":self.accountTF.text,@"upwd":encryptsecret} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
           
            [UserModel defaultUser].address = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"address"]];
            [UserModel defaultUser].area = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"area"]];
            [UserModel defaultUser].city = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"city"]];
            [UserModel defaultUser].del = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"del"]];
            [UserModel defaultUser].face_pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"face_pic"]];
            [UserModel defaultUser].g_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"g_id"]];
            [UserModel defaultUser].g_name = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"g_name"]];
            [UserModel defaultUser].is_help = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"is_help"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].pay_pwd = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"pay_pwd"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].province = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"province"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"real_state"]];
            [UserModel defaultUser].real_time = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"real_time"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"token"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].uid = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].umark = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"umark"]];
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].uname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"uname"]];
            [UserModel defaultUser].upwd = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"upwd"]];
            [UserModel defaultUser].user_pic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_pic"]];
            
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].invest_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"invest_count"]];
            [UserModel defaultUser].item_count = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"item_count"]];
            [UserModel defaultUser].user_server = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_server"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"real_state"]];
            [UserModel defaultUser].nickname = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"nickname"]];

            [UserModel defaultUser].loginstatus = YES;
            [usermodelachivar achive];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshInterface" object:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }else if([responseObject[@"code"] integerValue] == 412){
            self.serviceNumLabel.hidden = NO;
            self.serviceNumLabel.text = [NSString stringWithFormat:@"客服电话:%@",[UserModel defaultUser].user_server];

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }else{

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];

}
- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
