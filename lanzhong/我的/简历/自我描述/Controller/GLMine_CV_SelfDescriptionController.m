//
//  GLMine_CV_SelfDescriptionController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_SelfDescriptionController.h"

@interface GLMine_CV_SelfDescriptionController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_CV_SelfDescriptionController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"自我描述";
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    if (self.i_info.length != 0) {
        self.textV.text = self.i_info;
        self.textV.textColor = [UIColor blackColor];
    }
    
}

- (IBAction)ensure:(id)sender {
    
    if (self.textV.text.length == 0 || [self.textV.text isEqualToString:@"请输入自我描述"]) {
        [SVProgressHUD showErrorWithStatus:@"请输入自我描述(120字以内)"];
        return;
    }

    if (self.textV.text.length > 120) {
        [SVProgressHUD showErrorWithStatus:@"自我描述在120字以内"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"i_info"] = self.textV.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_ADD_DES_URL paramDic:dic finish:^(id responseObject) {
        
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

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    if ([textView.text isEqualToString:@"请输入自我描述"]) {
        
        self.textV.textColor = [UIColor blackColor];
        self.textV.text = @"";
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        self.textV.textColor = [UIColor lightGrayColor];
        self.textV.text = @"请输入自我描述";
    }
    
    return YES;
}

@end
