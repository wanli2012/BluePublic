//
//  GLMine_WalletController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletController.h"
#import "GLMine_AddCardController.h"//添加银行卡
#import "GLMine_WalletCardChooseController.h"//选择银行卡
#import "GLMine_WalletModel.h"
#import "QQPopMenuView.h"
#import "GLMine_Wallet_ExchangeController.h"//兑换记录界面
#import "GLMine_Wallet_RechargeController.h"//充值记录界面

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"


@interface GLMine_WalletController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIButton *ensurePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureExchangeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *addImageV;
@property (weak, nonatomic) IBOutlet UILabel *addCardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;//余额
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;//银行名字
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;//银行卡号
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *exchangeTextF;//兑换金额

@property (weak, nonatomic) IBOutlet UIImageView *weixinImageV;
@property (weak, nonatomic) IBOutlet UIImageView *alipayImageV;

@property (nonatomic, copy)NSString *bank_id;//银行名字
@property (nonatomic, copy)NSString  *pay_type;//支付方式1支付宝 2微信

@property (nonatomic, assign)BOOL isHaveDian;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLMine_WalletModel *model;

@end

@implementation GLMine_WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"钱包";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    self.topBgView.layer.cornerRadius = 5.f;
    
    self.topBgView.layer.shadowOpacity = 0.2f;
    self.topBgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.topBgView.layer.shadowRadius = 2.f;
    
    self.ensurePayBtn.layer.cornerRadius = 5.f;
    self.ensureExchangeBtn.layer.cornerRadius = 5.f;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [btn setTitle:@"明细" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRequest) name:@"addCardNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(postRequest) name:@"deleteBankCardNotification" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    self.pay_type = @"2";
    [self postRequest];
 
}

- (void)postRequest{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kBACK_DATA_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            self.model = [GLMine_WalletModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self updateBankInfo];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
}

- (void)updateBankInfo {
    
    self.balanceLabel.text = self.model.umonry;

    if (self.model.back_info.count > 0) {
        
        self.bankNameLabel.text = self.model.back_info[0].bank_name;
        self.bankNumLabel.text = self.model.back_info[0].bank_num;
        self.bank_id = self.model.back_info[0].bank_id;
        [self isHiddenTheAddImage:YES];
        
    }else{
        [self isHiddenTheAddImage:NO];
    }
}

//是否隐藏
- (void)isHiddenTheAddImage:(BOOL)isHidden{
    
    self.addImageV.hidden = isHidden;
    self.addCardLabel.hidden = isHidden;
    
    self.bankIconImageV.hidden = !isHidden;
    self.bankNameLabel.hidden = !isHidden;
    self.bankNumLabel.hidden = !isHidden;
    self.arrowImageV.hidden = !isHidden;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.model.back_info.count == 0) {
        [self isHiddenTheAddImage:NO];
    }else{
        [self isHiddenTheAddImage:YES];
    }
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 明细
- (void)detail{

    NSArray *arr = @[@{@"title":@"兑换明细",@"imageName":@""},@{@"title":@"充值明细",@"imageName":@""}];
    QQPopMenuView *popview = [[QQPopMenuView alloc] initWithItems:arr width:130 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 30, 64 + 5) action:^(NSInteger index) {
        
        self.hidesBottomBarWhenPushed = YES;
        switch (index) {
            case 0:
            {
                GLMine_Wallet_ExchangeController *exchangeVC = [[GLMine_Wallet_ExchangeController alloc] init];
                [self.navigationController pushViewController:exchangeVC animated:YES];
            }
                break;
            case 1:
            {
                GLMine_Wallet_RechargeController*rechargeVC = [[GLMine_Wallet_RechargeController alloc] init];
                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [popview show];
}

#pragma mark - 确认兑换
- (IBAction)exchange:(id)sender {
 
    if(self.bank_id.length == 0){
        [MBProgressHUD showError:@"请选择银行卡"];
        return ;
    }
    
    if(self.moneyTextF.text.length == 0){
        [MBProgressHUD showError:@"请输入金额"];
        return;
    }
    
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.moneyTextF.text doubleValue]];
    double moneyf = [money doubleValue];

    if (moneyf <= 0.0) {
        [MBProgressHUD showError:@"金额必须大于0"];
        return;
    }
    
    if ([self.moneyTextF.text integerValue] % 100 != 0) {
        [MBProgressHUD showError:@"兑换金额必须是100的整数倍!"];
        return;
    }
    
    if([self.moneyTextF.text doubleValue] /100 > 0){
        if([self.moneyTextF.text doubleValue] - [self.moneyTextF.text integerValue]/100 *100 != 0){
            [MBProgressHUD showError:@"兑换金额必须是100的整数倍!"];
            return;
        }
    }else{
        [MBProgressHUD showError:@"兑换金额必须是100的整数倍!"];
        return;
    }
    
    if ([self.moneyTextF.text integerValue] > [self.balanceLabel.text integerValue]){
        [MBProgressHUD showError:@"余额不足!"];
        return;
    }

    if (self.passwordTextF.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"兑换须知:你确定要兑换%@?",self.moneyTextF.text];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"兑换" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"money"] = [NSString stringWithFormat:@"%zd",[self.moneyTextF.text integerValue]];
        dict[@"bank_id"] = self.bank_id;
        dict[@"pwd"] = self.passwordTextF.text;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kEXCHANGE_MONEY_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                [self updateBankInfo];
                
                //两个浮点数 减法不正确,才用的这个办法   我也没想通,妈的
                NSDecimalNumber*jiafa1 = [NSDecimalNumber decimalNumberWithString:self.model.umonry];
                NSDecimalNumber*jiafa2 = [NSDecimalNumber decimalNumberWithString:self.moneyTextF.text];
                
                NSDecimalNumber*jianfa = [jiafa1 decimalNumberBySubtracting:jiafa2];
                
                self.balanceLabel.text = [NSString stringWithFormat:@"%@",jianfa];
                [MBProgressHUD showSuccess:responseObject[@"message"]];
                
                self.moneyTextF.text = nil;
                self.passwordTextF.text = nil;
                
            }else{
                
                [MBProgressHUD showError:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
        }];
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 充值操作
- (IBAction)paySure:(id)sender {
    
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.exchangeTextF.text doubleValue]];
    CGFloat moneyf = [money doubleValue];
    
    if(moneyf <= 0.0){
        [MBProgressHUD showError:@"请输入金额"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"money"] = [NSString stringWithFormat:@"%.2f",[self.exchangeTextF.text doubleValue]];
    dict[@"pay_type"] = self.pay_type;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kRECHARGE_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            if([self.pay_type integerValue] == 1){//支付宝支付
                
                [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"] fromScheme:@"lanzhongAlipay" callback:^(NSDictionary *resultDic) {
                    
                    NSInteger orderState = [resultDic[@"resultStatus"] integerValue];
                    if (orderState == 9000) {
                        self.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                        self.hidesBottomBarWhenPushed = NO;
                        
                    }else{
                        NSString *returnStr;
                        switch (orderState) {
                            case 8000:
                                returnStr=@"订单正在处理中";
                                break;
                            case 4000:
                                returnStr=@"订单支付失败";
                                break;
                            case 6001:
                                returnStr=@"订单取消";
                                break;
                            case 6002:
                                returnStr=@"网络连接出错";
                                break;
                                
                            default:
                                break;
                        }
                        
                        [MBProgressHUD showError:returnStr];
                    }
                }];
                
            }else{//微信支付
                [MBProgressHUD showError:responseObject[@"message"]];
                //调起微信支付
                PayReq* req = [[PayReq alloc] init];
                req.openID=responseObject[@"data"][@"wxinpay"][@"appid"];
                req.partnerId = responseObject[@"data"][@"wxinpay"][@"partnerid"];
                req.prepayId = responseObject[@"data"][@"wxinpay"][@"prepayid"];
                req.nonceStr = responseObject[@"data"][@"wxinpay"][@"noncestr"];
                req.timeStamp = [responseObject[@"data"][@"wxinpay"][@"timestamp"] intValue];
                req.package = responseObject[@"data"][@"wxinpay"][@"packages"];
                req.sign = responseObject[@"data"][@"wxinpay"][@"sign"];
                [WXApi sendReq:req];
            }

        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

-(void)wxpaysucess{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//选择支付方式
- (IBAction)weixinPay:(id)sender {
    
    self.weixinImageV.image = [UIImage imageNamed:@"mine_choice"];
    self.alipayImageV.image = [UIImage imageNamed:@"nochoice1"];
    self.pay_type = @"2";
}

- (IBAction)alipay:(id)sender {
    
    self.weixinImageV.image = [UIImage imageNamed:@"nochoice1"];
    self.alipayImageV.image = [UIImage imageNamed:@"mine_choice"];
    self.pay_type = @"1";
}

- (IBAction)switchFunc:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        
        self.rechargeView.hidden = YES;
    
    }else if (sender.selectedSegmentIndex == 1){
        
        self.rechargeView.hidden = NO;
    }
}

#pragma mark - 添加银行卡
- (IBAction)addCard:(id)sender {
    if ([[UserModel defaultUser].real_state integerValue] == 0 || [[UserModel defaultUser].real_state integerValue] == 2) {
        [MBProgressHUD showError:@"请前往个人中心实名认证"];
        return;
    }else if([[UserModel defaultUser].real_state integerValue] == 3){
        [MBProgressHUD showError:@"实名认证审核中,请等待"];
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
        GLMine_AddCardController *addVC = [[GLMine_AddCardController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

#pragma mark - 选择银行卡
- (IBAction)chooseCard:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_WalletCardChooseController *cardChooseVC = [[GLMine_WalletCardChooseController alloc] init];
    
    cardChooseVC.block = ^(NSString *bankName,NSString *bankNum,NSString *bank_id){
        self.bankNameLabel.text = bankName;
        self.bankNumLabel.text = bankNum;
        self.bank_id = bank_id;
        [self isHiddenTheAddImage:YES];
    };
    
    [self.navigationController pushViewController:cardChooseVC animated:YES];
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.moneyTextF) {
        [self.passwordTextF becomeFirstResponder];
    }else if(textField == self.passwordTextF){
        [self.passwordTextF resignFirstResponder];
    }else if(textField == self.exchangeTextF){
        [self.exchangeTextF resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.moneyTextF) {
        return [self validateNumber:string];
    }
    
    if (textField == self.exchangeTextF) {
        /*
         * 不能输入.0-9以外的字符。
         * 设置输入框输入的内容格式
         * 只能有一个小数点
         * 小数点后最多能输入两位
         * 如果第一位是.则前面加上0.
         * 如果第一位是0则后面必须输入点，否则不能输入。
         */
        
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                [MBProgressHUD showError:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                [MBProgressHUD showError:@"最多只能输入一个小数点"];
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [MBProgressHUD showError:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
            
        }
    }
    
    return YES;

}

@end
