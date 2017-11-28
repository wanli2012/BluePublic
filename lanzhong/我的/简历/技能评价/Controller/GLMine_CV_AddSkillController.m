//
//  GLMine_CV_AddSkillController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_AddSkillController.h"

@interface GLMine_CV_AddSkillController ()

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (nonatomic, copy)NSString * mastery;

@property (weak, nonatomic) IBOutlet UIImageView *levelImageV;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV3;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV4;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageV5;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_CV_AddSkillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"技能评价";
    self.saveBtn.layer.cornerRadius = 5.f;
    [self setOriginal];
}

- (void)setOriginal {
    
    if (self.model) {
        self.nameTF.text = self.model.skill_name;
        self.mastery = self.model.mastery;
    }
    if (self.mastery.length == 0) {
        self.mastery = @"0";
    }
    
    [self setSelectImage:[self.mastery integerValue]];
}

#pragma mark - 保存
- (IBAction)save:(id)sender {
    if(self.nameTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入公司名称"];
        return;
    }
    if(self.mastery.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择熟练程度"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"skill_id"] = @(self.type);
    dic[@"skill_name"] = self.nameTF.text;
    dic[@"mastery"] = self.mastery;
   
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_ADD_SKILL_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GLMine_CV_BaseInfoNotification" object:nil];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

//设置熟练程度
- (IBAction)selecteLevel:(UITapGestureRecognizer *)sender {

    [self setSelectImage:sender.view.tag-10];
    NSString *str = [NSString stringWithFormat:@"%zd",sender.view.tag - 10];
    self.mastery = str;
}

- (void)setSelectImage:(NSInteger)index
{
    self.levelImageV.image = [UIImage imageNamed:@"address_nochoice"];
    self.levelImageV2.image = [UIImage imageNamed:@"address_nochoice"];
    self.levelImageV3.image = [UIImage imageNamed:@"address_nochoice"];
    self.levelImageV4.image = [UIImage imageNamed:@"address_nochoice"];
    self.levelImageV5.image = [UIImage imageNamed:@"address_nochoice"];
    
    switch (index) {
        case 1:
        {
            self.levelImageV.image = [UIImage imageNamed:@"address_choice"];
        }
            break;
        case 2:
        {
            self.levelImageV2.image = [UIImage imageNamed:@"address_choice"];
        }
            break;
        case 3:
        {
            self.levelImageV3.image = [UIImage imageNamed:@"address_choice"];
        }
            break;
        case 4:
        {
            self.levelImageV4.image = [UIImage imageNamed:@"address_choice"];
        }
            break;
        case 5:
        {
            self.levelImageV5.image = [UIImage imageNamed:@"address_choice"];
        }
            break;
        default:
            break;
    }
}

@end
