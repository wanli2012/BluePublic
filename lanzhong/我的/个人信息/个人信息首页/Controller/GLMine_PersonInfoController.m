//
//  GLMine_PersonInfoController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"
#import "GLMine_PersonInfo_AddressChooseController.h"//地址选择

@interface GLMine_PersonInfoController ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;


@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;//IDNum
@property (weak, nonatomic) IBOutlet UITextField *trueNameTF;//真实姓名
@property (weak, nonatomic) IBOutlet UITextField *IDCardNumTF;//身份证号
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;//手机号
@property (weak, nonatomic) IBOutlet UITextField *recommendTF;//推荐人TF
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT - 64;
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.phoneTF.text = [UserModel defaultUser].phone;
    self.recommendTF.text = [UserModel defaultUser].g_name;
    self.userNameLabel.text = [UserModel defaultUser].uname;
    
    self.trueNameTF.text = [UserModel defaultUser].truename;
    self.IDCardNumTF.text = [UserModel defaultUser].idcard;
    
    self.nickNameLabel.text = [UserModel defaultUser].nickname;
    
    switch ([[UserModel defaultUser].real_state integerValue]) {//实名认证状态 0未认证  1成功   2失败   3审核中
        case 0:
        {
            self.ensureBtn.hidden = NO;
        }
            break;
        case 1:
        {
            self.ensureBtn.hidden = YES;
        }
            break;
        case 2:
        {
            self.ensureBtn.hidden = NO;
            self.ensureBtn.enabled = NO;
            [self.ensureBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            
        }
            break;
        case 3:
        {
            self.ensureBtn.hidden = NO;
            self.ensureBtn.enabled = NO;
            [self.ensureBtn setTitle:@"审核中" forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)ensure:(id)sender {

    if (self.trueNameTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入真实姓名"];
        return;
    }else if(![predicateModel IsChinese:self.trueNameTF.text]){
        [MBProgressHUD showError:@"真实姓名应该是汉字"];
        return;
    }
    
    if (self.IDCardNumTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入身份证号"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"type"] = @"2";
    dict[@"truename"] = self.trueNameTF.text;
    dict[@"idcard"] = self.IDCardNumTF.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kUSER_INFO_SAVE_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
        }
        
        [MBProgressHUD showError:responseObject[@"message"]];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];

}

//头像修改
- (IBAction)picModify:(id)sender {
    
}

//昵称修改
- (IBAction)nameModify:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"昵称修改" message:@"what's your name?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入昵称";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"type"] = @"1";
        dict[@"nickname"] = alertVC.textFields.lastObject.text;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kUSER_INFO_SAVE_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
            }
            
            [MBProgressHUD showError:responseObject[@"message"]];
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];

    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (IBAction)address:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfo_AddressChooseController *addressVC = [[GLMine_PersonInfo_AddressChooseController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}


@end
