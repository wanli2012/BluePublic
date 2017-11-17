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
#import "GLHomePageNoticeView.h"
#import "RSAEncryptor.h"

#import "BaseNavigationViewController.h"
#import "GLLoginController.h"

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

@property (nonatomic, strong)UIView  *maskV;//遮罩
@property (nonatomic, strong)GLHomePageNoticeView *noticeView;//兑换须知
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;//手续费Label

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
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = NO;
            [usermodelachivar achive];
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            loginVC.sign = 1;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

- (void)updateBankInfo {
    double fee = [self.model.back_counter doubleValue] * 100;
    
    if(self.model.back_counter.length == 0 || fee == 0.0){
        self.feeLabel.hidden = YES;
    }else{
        self.feeLabel.hidden = NO;
        self.feeLabel.text = [NSString stringWithFormat:@"*注:兑换手续费为提交金额的%.2f%%",fee];
    }
    
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
        
        [SVProgressHUD showErrorWithStatus:@"请选择银行卡"];
        return ;
    }
    
    if(self.moneyTextF.text.length == 0){
        
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.moneyTextF.text doubleValue]];
    double moneyf = [money doubleValue];
    
    if (moneyf <= 0.0) {
        [SVProgressHUD showErrorWithStatus:@"金额必须大于0"];
        return;
    }
    
    if ([self.moneyTextF.text integerValue] % 100 != 0) {
        
        [SVProgressHUD showErrorWithStatus:@"兑换金额必须是100的整数倍!"];
        return;
    }
    
    if([self.moneyTextF.text doubleValue] /100 > 0){
        if([self.moneyTextF.text doubleValue] - [self.moneyTextF.text integerValue]/100 *100 != 0){
            [SVProgressHUD showErrorWithStatus:@"兑换金额必须是100的整数倍!"];
            return;
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"兑换金额必须是100的整数倍!"];
        return;
    }
    
    if ([self.moneyTextF.text integerValue] > [self.balanceLabel.text integerValue]){
        [SVProgressHUD showErrorWithStatus:@"余额不足!"];
        return;
    }
    
    if (self.passwordTextF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }

    [self initInterDataSorceinfomessage];//公告
 
}
- (void)sureExchange{
    
    NSString *encryptsecret = [RSAEncryptor encryptString:self.passwordTextF.text publicKey:public_RSA];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"money"] = [NSString stringWithFormat:@"%zd",[self.moneyTextF.text integerValue]];
    dict[@"bank_id"] = self.bank_id;
    dict[@"pwd"] = encryptsecret;
    
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
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            self.moneyTextF.text = nil;
            self.passwordTextF.text = nil;
        
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        [self dismiss];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self dismiss];
    }];

}
#pragma mark ----公告
-(void)initInterDataSorceinfomessage{
    
    CGFloat contentViewH = kSCREEN_HEIGHT / 2;
    CGFloat contentViewW = kSCREEN_WIDTH - 40;
    CGFloat contentViewX = 20;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskV];
    [window addSubview:self.noticeView];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:Exchange_Info_URL]];
    [self.noticeView.webView loadRequest:request];
    self.noticeView.frame = CGRectMake(contentViewX, (kSCREEN_HEIGHT - contentViewH)/2, contentViewW, contentViewH);
    //缩放
    self.noticeView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    self.noticeView.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        self.noticeView.alpha = 1;
    }];
}

- (void)dismiss{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.noticeView.transform = CGAffineTransformMakeScale(0.07, 0.07);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.noticeView.center = CGPointMake(kSCREEN_WIDTH - 30,30);
        } completion:^(BOOL finished) {
            [self.noticeView removeFromSuperview];
            [self.maskV removeFromSuperview];
            self.noticeView = nil;
            self.maskV = nil;
        }];
    }];
}

#pragma mark - 充值操作
- (IBAction)paySure:(id)sender {
    
    NSString *money = [NSString stringWithFormat:@"%.2f",[self.exchangeTextF.text doubleValue]];
    CGFloat moneyf = [money doubleValue];
    
    if(moneyf <= 0.0){
         [SVProgressHUD showErrorWithStatus:@"请输入金额"];
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
                        
                        [SVProgressHUD showErrorWithStatus:returnStr];
                    }
                }];
            }else{//微信支付
                
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
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
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
        self.feeLabel.hidden = NO;
    }else if (sender.selectedSegmentIndex == 1){
        
        self.rechargeView.hidden = NO;
        self.feeLabel.hidden = YES;
    }
}

#pragma mark - 添加银行卡
- (IBAction)addCard:(id)sender {
    if ([[UserModel defaultUser].real_state integerValue] == 0 || [[UserModel defaultUser].real_state integerValue] == 2) {
         [SVProgressHUD showErrorWithStatus:@"请前往个人中心实名认证"];
        return;
    }else if([[UserModel defaultUser].real_state integerValue] == 3){
         [SVProgressHUD showErrorWithStatus:@"实名认证审核中,请等待"];
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
    
    if (textField == self.moneyTextF || textField == self.exchangeTextF) {
        return [self validateNumber:string];
    }
    
    return YES;
}

- (UIView *)maskV{
    if (!_maskV) {
        _maskV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _maskV.backgroundColor = [UIColor blackColor];
        _maskV.alpha = 0.3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismiss)];
        [_maskV addGestureRecognizer:tap];
        
    }
    return _maskV;
}

- (GLHomePageNoticeView *)noticeView{
    if (!_noticeView) {
        
        _noticeView = [[NSBundle mainBundle] loadNibNamed:@"GLHomePageNoticeView" owner:nil options:nil].lastObject;
        
        _noticeView.contentViewW.constant = kSCREEN_WIDTH - 40;
        _noticeView.contentViewH.constant = kSCREEN_HEIGHT / 2 - 40;
        _noticeView.layer.cornerRadius = 5;
        _noticeView.layer.masksToBounds = YES;
        [_noticeView.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_noticeView.sureBtn addTarget:self action:@selector(sureExchange) forControlEvents:UIControlEventTouchUpInside];
        
        _noticeView.titleLabel.text = @"兑换须知";
        //设置webView
        _noticeView.webView.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH - 40, 0);
        _noticeView.webView.scalesPageToFit = YES;
        _noticeView.webView.autoresizesSubviews = NO;
        _noticeView.webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _noticeView.webView.scrollView.bounces = NO;
        
        _noticeView.webView.backgroundColor = [UIColor clearColor];
        _noticeView.webView.opaque = NO;
        
    }
    return _noticeView;
}

@end
