//
//  GLMine_SalePublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SalePublishController.h"

@interface GLMine_SalePublishController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名字
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//描述

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//总耗资
@property (weak, nonatomic) IBOutlet UILabel *totalPartnerLabel;//总参与人数
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期label
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@end

@implementation GLMine_SalePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noticeLabel.text = @"1、出售预估价格需在合理范围。\n2、为以防日后出现纠纷，建议双方达成书面协议。\n3、出售后项目的收益归被转让人所有";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 550;
    
    self.navigationItem.title = @"出售发布";
    
    self.submitBtn.layer.cornerRadius = 5.f;
    _isAgreeProtocol = NO;
    
}

/**
 是否同意协议

 */
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        
        self.signImageV.image = [UIImage imageNamed:@"publish_choice"];
    }else{
        self.signImageV.image = [UIImage imageNamed:@"publish_nochoice"];
    }
    
}

/**
 跳转到协议

 */
- (IBAction)toProtocol:(id)sender {
    
    NSLog(@"跳转到转让协议");
}

/**
 提交
 */
- (IBAction)submit:(id)sender {
    
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.priceTF) {
        [self.phoneTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    ///判断中除去删除键
    if (range.length == 1 && string.length == 0) {
        return YES;
        
    }else  if (![predicateModel inputShouldNumber:string]) {
        [SVProgressHUD showErrorWithStatus:@"此处只能输入数字"];
        return NO;
        
    }else if (textField.text.length > 10) {
        [SVProgressHUD showErrorWithStatus:@"你输入的内容太长了!"];
        [textField.text substringToIndex:10];
        return NO;
        
    }
    
    return YES;
}

@end
