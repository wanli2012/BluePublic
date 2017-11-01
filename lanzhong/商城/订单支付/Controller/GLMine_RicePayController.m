//
//  GLMine_RicePayController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/8/13.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLMine_RicePayController.h"
#import "LBMineCenterPayPagesTableViewCell.h"
//#import "LBIntegralMallViewController.h"
#import "GLOrderPayView.h"
#import "GLSet_MaskVeiw.h"
#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"
#import "GLMine_RicePayModel.h"
#import "GLBusiness_DetailController.h"


@interface GLMine_RicePayController ()
{
    LoadWaitView *_loadV;
    GLSet_MaskVeiw *_maskV;
//    UIView *_maskView;
//    GLOrderPayView *_contentView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIButton *sureBt;

@property (strong, nonatomic)  NSMutableArray *dataarr;
@property (strong, nonatomic)  NSMutableArray *selectB;
@property (assign, nonatomic)  NSInteger selectIndex;
//@property (weak, nonatomic) IBOutlet UILabel *orderType;
//@property (weak, nonatomic) IBOutlet UILabel *ordercode;
@property (weak, nonatomic) IBOutlet UILabel *orderMoney;
@property (weak, nonatomic) IBOutlet UILabel *orderMTitleLb;

@property (nonatomic, assign)NSInteger paySituation;//1:米劵支付 2:米劵+米子  3:米劵+微信 4:米劵+支付宝 5:米子支付 6:微信支付 7:支付宝
@property (nonatomic, strong)GLOrderPayView *contentView;

@property (nonatomic, strong)UIView *maskView;
@property (nonatomic, strong) GLMine_RicePayModel *payModel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//提示类型,区分从哪里跳进来的

@end

@implementation GLMine_RicePayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.title = @"支付页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.selectIndex = -1;
    
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerNib:[UINib nibWithNibName:@"LBMineCenterPayPagesTableViewCell" bundle:nil] forCellReuseIdentifier:@"LBMineCenterPayPagesTableViewCell"];

    self.orderMoney.text = [NSString stringWithFormat:@"%.2f",[self.orderPrice floatValue]];
    self.orderMTitleLb.text = @"订单金额:";
    
    if(self.signIndex == 1){
        self.typeLabel.text = @"订单支付";
    }else{
        self.typeLabel.text = @"下单成功";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postRepuest:paySituation:) name:@"input_PasswordNotification" object:nil];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Alipaysucess) name:@"Alipaysucess" object:nil];
    
    /**
     *微信支付成功 回调
     */
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxpaysucess) name:@"wxpaysucess" object:nil];
    
    /**
     *判断是否展示支付
     */
    
    [self isShowPayInterface];
}

-(void)isShowPayInterface{

    [self.dataarr removeAllObjects];
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kPAY_SWITCH_URL paramDic:@{} finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
    
            
            self.payModel = [GLMine_RicePayModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (self.payModel.credit.open) {
                
                [self.dataarr addObject:@{@"image":@"余额",@"title":@"余额支付",@"index":@"3"}];
            }
            if (self.payModel.alipay.open){
                
                [self.dataarr addObject:@{@"image":@"zhifubao",@"title":@"支付宝支付",@"index":@"1"}];
            }
            if (self.payModel.wechat.open){
                
                [self.dataarr addObject:@{@"image":@"weixin",@"title":@"微信支付",@"index":@"2"}];
            }
        }
        [self setPayType];

        [self.tableview reloadData];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self.tableview reloadData];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
}
- (IBAction)pop:(id)sender {
    
    if(self.signIndex == 1){
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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

-(void)wxpaysucess{
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LBMineCenterPayPagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LBMineCenterPayPagesTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.payimage.image = [UIImage imageNamed:_dataarr[indexPath.row][@"image"]];
    cell.paytitile.text = _dataarr[indexPath.row][@"title"];

    if ([self.selectB[indexPath.row] boolValue] == NO) {
        
        cell.selectimage.image = [UIImage imageNamed:@"nochoice1"];
        
    }else{
        
        cell.selectimage.image = [UIImage imageNamed:@"mine_choice"];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self choosePayType:indexPath.row];

    [self.tableview reloadData];
    
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

- (void)dismiss{
    
    [_contentView.passwordF resignFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _contentView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 300);
    }completion:^(BOOL finished) {
 
        [self.maskView removeFromSuperview];
    }];
}

//确定支付
- (IBAction)surebutton:(UIButton *)sender {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"order_id"] = self.order_id;
    dict[@"order_money"] = self.orders_Price;
    if (self.signIndex == 0) {
        dict[@"num_num"] = @2;
    }else{
        dict[@"num_num"] = @1;
    }
    
    NSInteger index = [self.dataarr[self.selectIndex][@"index"] integerValue];
    switch (index) {
        case 3://余额
        {
            dict[@"paytype"] = @"3";
            [self balancePay:dict];
        }
            break;
        case 2://微信
        {
            dict[@"paytype"] = @"2";
        }
            break;
        case 1://支付宝
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
    [NetworkManager requestPOSTWithURLStr:kORDER_PAY_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            NSInteger index = [self.dataarr[self.selectIndex][@"index"] integerValue];
            switch (index) {
                case 2://微信
                {
                    
                }
                    break;
                case 1://支付宝
                {
                    [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"] fromScheme:@"lanzhongAlipay" callback:^(NSDictionary *resultDic) {
                        
                        NSInteger orderState = [resultDic[@"resultStatus"] integerValue];
                        if (orderState == 9000) {
                            
                            if (self.signIndex == 1) {
                                
                                self.block();
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }

                            
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
                }
                    break;
                default:
                    break;
            }
            
            
            
        }
        [MBProgressHUD showError:responseObject[@"message"]];
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];

}

//余额支付
- (void)balancePay:(NSMutableDictionary *)dict{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入登录密码";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (alertVC.textFields.lastObject.text.length == 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD showError:@"请输入密码"];
            });
            
            return;
        }
        
        dict[@"upwd"] = alertVC.textFields.lastObject.text;

        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kORDER_PAY_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                if (self.signIndex == 1) {
                    
                    self.block();
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                
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

//支付请求
- (void)postRepuest:(NSNotification *)sender paySituation:(NSInteger )paySituation{
    
    NSLog(@"支付完成");
    [self dismiss];
}

- (void)WeChatPay:(NSString *)payType{

//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = [UserModel defaultUser].token;
//    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"order_id"] = self.order_id;
//    dict[@"paytype"] = payType;
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
//    [NetworkManager requestPOSTWithURLStr:@"Shop/payParam" paramDic:dict finish:^(id responseObject) {
    
//        [_loadV removeloadview];
//        [self dismiss];
//        if ([responseObject[@"code"] integerValue] == 1){
//            //调起微信支付
//            PayReq* req = [[PayReq alloc] init];
//            req.openID=responseObject[@"data"][@"weixinpay"][@"appid"];
//            req.partnerId = responseObject[@"data"][@"weixinpay"][@"partnerid"];
//            req.prepayId = responseObject[@"data"][@"weixinpay"][@"prepayid"];
//            req.nonceStr = responseObject[@"data"][@"weixinpay"][@"noncestr"];
//            req.timeStamp = [responseObject[@"data"][@"weixinpay"][@"timestamp"] intValue];
//            req.package = responseObject[@"data"][@"weixinpay"][@"package"];
//            req.sign = responseObject[@"data"][@"weixinpay"][@"sign"];
//            [WXApi sendReq:req];
//            
//        }else{
//            
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//    } enError:^(NSError *error) {
//        [MBProgressHUD showError:error.localizedDescription];
//        [_loadV removeloadview];
    
//    }];
}

- (void)alipay:(NSString *)payType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"order_id"] = self.order_id;
    dict[@"paytype"] = payType;
    
    [NetworkManager requestPOSTWithURLStr:@"Shop/payParam" paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self dismiss];
        if ([responseObject[@"code"] integerValue] == 1){
            
            [[AlipaySDK defaultService]payOrder:responseObject[@"data"][@"alipay"][@"url"] fromScheme:@"univerAlipay" callback:^(NSDictionary *resultDic) {
                
                NSInteger orderState=[resultDic[@"resultStatus"] integerValue];
                if (orderState==9000) {
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
            
        }else{
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [MBProgressHUD showError:error.localizedDescription];
        [_loadV removeloadview];
        
    }];
}

//支付宝客户端支付成功之后 发送通知
-(void)Alipaysucess{
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}


- (void)pay:(NSNotification *)sender{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = [UserModel defaultUser].token;
//    dict[@"uid"] = [UserModel defaultUser].uid;
//    dict[@"is_rmb"] = @0;
//    dict[@"is_mark"] = @3;
//    dict[@"orderId"] = self.order_id;
////    dict[@"pay_type"] = ;
////    dict[@"order_id"] =[RSAEncryptor encryptString:[NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn] publicKey:public_RSA];
////    
////    dict[@"password"] = [RSAEncryptor encryptString:[sender.userInfo objectForKey:@"password"] publicKey:public_RSA];
//    
//    dict[@"order_id"] = [NSString stringWithFormat:@"%@_%@_%@",self.order_sh,self.order_id,self.order_sn];
//    dict[@"password"] = [sender.userInfo objectForKey:@"password"];
//    
//    
//    [NetworkManager requestPOSTWithURLStr:@"shop/getPayType" paramDic:dict finish:^(id responseObject) {
//        
//        [_loadV removeloadview];
//        [self dismiss];
//        
//        if ([responseObject[@"code"] integerValue] == 1){
//            
//                [MBProgressHUD showError:responseObject[@"message"]];
//        }else{
//            
//            [MBProgressHUD showError:responseObject[@"message"]];
//        }
//        
//    } enError:^(NSError *error) {
//        [MBProgressHUD showError:error.localizedDescription];
//        [_loadV removeloadview];
//        
//    }];
//
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

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.sureBt.layer.cornerRadius = 4;
    self.sureBt.clipsToBounds = YES;
    
}
- (GLOrderPayView *)contentView{
    
    if (!_contentView) {
        _contentView = [[NSBundle mainBundle] loadNibNamed:@"GLOrderPayView" owner:nil options:nil].lastObject;
        _contentView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, 0);
    }
    
    return _contentView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
