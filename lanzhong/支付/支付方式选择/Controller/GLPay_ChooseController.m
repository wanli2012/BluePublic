//
//  GLPay_ChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_ChooseController.h"
#import "GLPay_CompletedController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
#import "GLOrderPayView.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "RSAEncryptor.h"

@interface GLPay_ChooseController ()<UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;

@property (nonatomic, strong)GLOrderPayView *contentView;

@property (nonatomic, strong)UIView *maskView;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UITextView *messageTextV;//留言textView
@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation GLPay_ChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付详情";
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.messageTextV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.messageTextV.layer.borderWidth = 1.f;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popScrectView) name:@"input_PasswordNotification" object:nil];
    /**
     *微信支付成功 回调
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    [self isShowPayInterface];
}

- (void)popScrectView{
    
    //弹出密码输入框
    CGFloat contentViewH = 300;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, contentViewH);
        [self.contentView.passwordF becomeFirstResponder];
        
    }];
    
    self.maskView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    
    [window addSubview:self.maskView];
    [window addSubview:self.contentView];
    
}

-(void)isShowPayInterface{

    [self.dataarr addObject:@{@"image":@"余额",@"title":@"余额支付"}];
    [self.dataarr addObject:@{@"image":@"weixin",@"title":@"微信支付"}];
    [self.dataarr addObject:@{@"image":@"zhifubao",@"title":@"支付宝支付"}];
    
    [self setPayType];
}

- (void)setPayType {

    [self.selectB addObject:@YES];
    
    if (self.dataarr.count <= 1) {
        return;
    }
    
    for ( int i = 1 ; i < self.dataarr.count; i++) {
        [self.selectB addObject:@NO];
    }
    self.selectIndex = 0;
  
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//选择方式
- (IBAction)switchPay:(UIButton *)sender {

}

//确认支付
- (IBAction)ensurePay:(id)sender {
    
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    if ([self.messageTextV.text isEqualToString:@"留言"]) {
        self.messageTextV.text = @"";
    }
    
    if([self.moneyTF.text doubleValue] <= 0){

        [SVProgressHUD showErrorWithStatus:@"支持金额必须大于0"];
        return;
    }

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"item_id"] = self.item_id;
    dict[@"money"] = @([self.moneyTF.text doubleValue]);
    dict[@"comment"] = self.messageTextV.text;
    dict[@"c_time"] = timeString;
    
    switch (self.selectIndex) {
        case 0://余额
        {
            dict[@"paytype"] = @"3";
            [self balancePay:dict];
        }
            break;
        case 1://微信
        {
            dict[@"paytype"] = @"2";
            [self cashPay:dict];
        }
            break;
        case 2://支付宝
        {
            dict[@"paytype"] = @"1";
            [self cashPay:dict];
        }
            break;
        default:
            break;
    }
}

//现金支付
- (void)cashPay:(NSMutableDictionary *)dict{
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kSUPPORT_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            switch (self.selectIndex) {
                case 1://微信
                {
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
                    break;
                case 2://支付宝
                {
                    [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"] fromScheme:@"lanzhongAlipay" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger orderState = [resultDic[@"resultStatus"] integerValue];
                        if (orderState == 9000) {
                            
                            self.hidesBottomBarWhenPushed = YES;
                            GLPay_CompletedController *completeVC = [[GLPay_CompletedController alloc] init];
                            completeVC.item_id = self.item_id;
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"supportNotification" object:nil];
                            [self.navigationController pushViewController:completeVC animated:YES];
                            
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
                }
                    break;
                default:
                    break;
            }
            
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = NO;
            [usermodelachivar achive];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(void)wxpaysucess{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"supportNotification" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//余额支付
- (void)balancePay:(NSMutableDictionary *)dict{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入登录密码";
        [textField setSecureTextEntry:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    __block typeof(self) weakself = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if(weakself.moneyTF.text.length == 0){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      
                [SVProgressHUD showErrorWithStatus:@"请输入支持金额"];
            });
            
            return;
        }
        NSString *encryptsecret = [RSAEncryptor encryptString:alertVC.textFields.lastObject.text publicKey:public_RSA];
        dict[@"upwd"] = encryptsecret;
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:weakself.view];
        [NetworkManager requestPOSTWithURLStr:kSUPPORT_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                weakself.hidesBottomBarWhenPushed = YES;
                GLPay_CompletedController *completeVC = [[GLPay_CompletedController alloc] init];
                completeVC.item_id = weakself.item_id;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"supportNotification" object:nil];
                
                [weakself.navigationController pushViewController:completeVC animated:YES];
                
            }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];

                [UserModel defaultUser].loginstatus = NO;
                [usermodelachivar achive];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@"留言"]) {
        self.messageTextV.textColor = [UIColor darkGrayColor];
        self.messageTextV.text = @"";
    }
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@""]) {
        
        self.messageTextV.textColor = [UIColor lightGrayColor];
        self.messageTextV.text = @"留言";
        
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
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.moneyTF) {
        return [self validateNumber:string];
    }

    return YES;
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:self.dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = self.dataarr[indexPath.row][@"title"];
    
    if ([self.selectB[indexPath.row] boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"nochoice1"];
        
    }else{
        
        cell.selectimage.image = [UIImage imageNamed:@"mine_choice"];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self choosePayType:indexPath.row];

    [self.tableView reloadData];
    
}

- (void)choosePayType:(NSInteger )index {
    
    if (self.selectIndex == -1) {
        
        BOOL a = [self.selectB[index] boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        self.selectIndex = index;
        
    }else{
        
        if (self.selectIndex == index) {
            return;
        }
        
        BOOL a = [self.selectB[index]boolValue];
        [self.selectB replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!a]];
        [self.selectB replaceObjectAtIndex:self.selectIndex withObject:[NSNumber numberWithBool:NO]];
        self.selectIndex = index;
    }
}

-(NSMutableArray*)dataarr{
    
    if (!_dataarr) {
        
        _dataarr = [NSMutableArray array];
    }
    
    return _dataarr;
}
-(NSMutableArray*)selectB{
    
    if (!_selectB) {
        _selectB=[NSMutableArray array];
    }
    
    return _selectB;
    
}
@end
