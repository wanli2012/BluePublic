//
//  GLMine_SalePublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/5.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_SalePublishController.h"
#import "GLBusiness_CertificationController.h"

@interface GLMine_SalePublishController ()<UITextFieldDelegate>
{
    BOOL _isAgreeProtocol;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *priceTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名字
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;//描述
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//耗资label
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//总耗资
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期label
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;//项目图片
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UITextField *inPriceTF;//买入价格
@property (weak, nonatomic) IBOutlet UITextField *investTF;//项目投资
@property (weak, nonatomic) IBOutlet UIView *inPriceView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *signImageV;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_SalePublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.noticeLabel.text = @"1、出售预估价格需在合理范围。\n2、为以防日后出现纠纷，建议双方达成书面协议。\n3、出售后项目的收益归被转让人所有";

    self.contentViewHeight.constant = 650;
    
    self.navigationItem.title = @"出售发布";
    
    self.bgView.layer.cornerRadius = 5.f;
    self.submitBtn.layer.cornerRadius = 5.f;
    _isAgreeProtocol = NO;
    
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:self.model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.detailLabel.text = self.model.info;
    self.totalPriceLabel.text = self.model.admin_money;
    self.projectNameLabel.text = self.model.title;
    
    if (self.model.s_time.length == 0 || self.model.need_time.length == 0) {
        self.dateView.hidden = YES;
        self.dateLabel.hidden = YES;
    }else{
        self.dateView.hidden = NO;
        self.dateLabel.hidden = NO;
    }
    
    NSString *startDate = [formattime formateTimeOfDate4:self.model.s_time];
    NSString *endDate = [[formattime formateTimeOfDate4:self.model.need_time] substringFromIndex:5];
    NSString *date = [NSString stringWithFormat:@"%@-%@",startDate,endDate];
    self.dateLabel.text = date;
    
    if (self.type == 2) {//1:出售(可出售) 2:编辑(售卖中)
        
        self.phoneTF.text = self.model.attorn_phone;
        self.priceTF.text = self.model.attorn_money;
        self.investTF.text = self.model.invest_money2;
        
        if ([self.model.is_sale integerValue] == 1) {//是否是购买来的 1是 0否
            self.middleViewHeight.constant = 100;
            self.inPriceView.hidden = NO;
            self.inPriceTF.text = self.model.attorn_money2;
        }else{
            self.middleViewHeight.constant = 50;
            self.inPriceView.hidden = YES;
        }
        
    }else{
        
        self.phoneTF.text = @"";
        self.priceTF.text = @"";
        self.investTF.text = self.model.invest_money1;
        
        if ([self.model.is_sale integerValue] == 1) {//是否是购买来的 1是 0否
            self.middleViewHeight.constant = 100;
            self.inPriceView.hidden = NO;
            self.inPriceTF.text = self.model.attorn_money1;
        }else{
            self.middleViewHeight.constant = 50;
            self.inPriceView.hidden = YES;
        }
    }
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

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *webVC = [GLBusiness_CertificationController new];
    webVC.url = Transfer_URL;
    webVC.navTitle = @"转让须知";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 提交
 */
- (IBAction)submit:(id)sender {
    
    if(self.priceTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入价格"];
        return;
    }
    
    if (![predicateModel valiMobile:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号不正确"];
        return;
    }
    if(!_isAgreeProtocol){
        [SVProgressHUD showErrorWithStatus:@"还未同意转让须知"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"invest_id"] = self.model.invest_id;
    dict[@"price"] = self.priceTF.text;
    dict[@"phone"] = self.phoneTF.text;
    
    NSString *url;
    if(self.type == 1){ //1:出售 2:编辑
        url = kProject_Release_URL;
    }else{
        url = kProject_Edit_URL;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:url paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Sale_PublishNotification" object:nil];
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
    }];
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

