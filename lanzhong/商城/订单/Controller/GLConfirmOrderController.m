//
//  GLConfirmOrderController.m
//  Universialshare
//
//  Created by 龚磊 on 2017/4/1.
//  Copyright © 2017年 四川三君科技有限公司. All rights reserved.
//

#import "GLConfirmOrderController.h"
#import "GLSet_MaskVeiw.h"
#import "GLMine_PersonInfo_AddressChooseController.h"
#import "GLOrderGoodsCell.h"
#import "GLConfirmOrderModel.h"
#import "GLMine_RicePayController.h"
#import "BaseNavigationViewController.h"
#import "GLLoginController.h"


@interface GLConfirmOrderController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    float _sumNum;//总价
    LoadWaitView * _loadV;
}

@property (nonatomic, strong)GLSet_MaskVeiw *maskV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

@property (weak, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;//运费Label
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;//实付总价

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray  *models;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

//收货人信息
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//留言
@property (weak, nonatomic) IBOutlet UITextView *remarkTextV;

@property (nonatomic, copy)NSString *address_id;
//@property (nonatomic, strong)UITextField *passwordTF;

@end

static NSString *ID = @"GLOrderGoodsCell";
@implementation GLConfirmOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"确认订单";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    self.contentViewW.constant = kSCREEN_WIDTH;
    self.contentViewH.constant = kSCREEN_HEIGHT + 49;

    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(ensurePassword:) name:@"input_PasswordNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAddress:) name:@"delAddressNotification" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLOrderGoodsCell" bundle:nil] forCellReuseIdentifier:ID];
    [self postAddressRequest];
    [self postGoodsDetail];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postAddressRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"page"] = @"1";
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    //请求地址
    [NetworkManager requestPOSTWithURLStr:kMYADDRESSLIST_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){

            if (![responseObject[@"data"] isEqual:[NSNull null]]) {
                if ([responseObject[@"data"] count] > 0) {
                    
                    NSDictionary *dic = responseObject[@"data"][0];
                    self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",dic[@"collect_name"]];
                    self.phoneLabel.text = [NSString stringWithFormat:@"tel:%@",dic[@"phone"]];
                    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",dic[@"province_name"],dic[@"city_name"],dic[@"area_name"],dic[@"address"]];
                    self.address_id = [NSString stringWithFormat:@"%@",dic[@"address_id"]];

                }
        
                for (NSDictionary *dic in responseObject[@"data"]) {
                    if ([dic[@"is_default"] intValue] == 1) {
                        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",dic[@"collect_name"]];
                        self.phoneLabel.text = [NSString stringWithFormat:@"tel:%@",dic[@"phone"]];
                        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",dic[@"province_name"],dic[@"city_name"],dic[@"area_name"],dic[@"address"]];
                        self.address_id = [NSString stringWithFormat:@"%@",dic[@"address_id"]];
                    }
                }
            }
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

- (void)postGoodsDetail{
    
    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
    dict1[@"token"] = [UserModel defaultUser].token;
    dict1[@"uid"] = [UserModel defaultUser].uid;
    dict1[@"goods_id"] = self.goods_id;
    dict1[@"num"] = self.goods_count;
    dict1[@"spec_id"] = self.goods_spec;
    
    //请求商品信息
    [NetworkManager requestPOSTWithURLStr:kBUY_GOODS_URL paramDic:dict1 finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            _sumNum = 0.f;
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLConfirmOrderModel *model = [GLConfirmOrderModel mj_objectWithKeyValues:dic];
                [self.models addObject:model];
                
                CGFloat sum = [model.goods_price floatValue] * [model.num integerValue];
                _sumNum += sum;
                
            }
            self.totalSumLabel.text = [NSString stringWithFormat:@"合计:¥%.2f",_sumNum];
            self.tableViewHeight.constant = _models.count * 117;
            self.contentViewH.constant = _models.count * 117 + 220;
            [self.tableView reloadData];
            
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
            [UserModel defaultUser].loginstatus = NO;
            [usermodelachivar achive];
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            loginVC.sign = 1;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];

            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
    
}

- (void)refreshAddress:(NSNotification *)notification{
    
    [self postAddressRequest];
    
}

- (IBAction)addressChoose:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfo_AddressChooseController *modifyAD = [[GLMine_PersonInfo_AddressChooseController alloc] init];
    
    modifyAD.block = ^(NSString *name,NSString *phone,NSString *address,NSString *addressid){
        
        self.nameLabel.text = [NSString stringWithFormat:@"收货人:%@",name];
        self.phoneLabel.text = [NSString stringWithFormat:@"电话号码:%@",phone];
        self.addressLabel.text = [NSString stringWithFormat:@"%@",address];
        self.address_id = addressid;
        
    };
    
    [self.navigationController pushViewController:modifyAD animated:YES];

}

- (void)dismiss {
    
}

- (void)ensurePassword:(NSNotification *)userInfo{
    [self dismiss];

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

#pragma mark - 订单提交
- (IBAction)submitOrder:(UIButton *)sender {

    if (self.nameLabel.text.length <=0 ) {
    
        [SVProgressHUD showErrorWithStatus:@"请填写收货信息"];
        return;
    }
    if(self.address_id.length == 0){
  
        [SVProgressHUD showErrorWithStatus:@"请先选择地址"];
        return;
    }
    
    if (self.goods_type == 2) {//积分商品
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入登录密码";
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (alertVC.textFields.lastObject.text.length == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showErrorWithStatus:@"未输入密码"];
                });
                return;
            }
            
            NSString *encryptsecret = [RSAEncryptor encryptString:alertVC.textFields.lastObject.text publicKey:public_RSA];
            dict[@"upwd"] = encryptsecret;
            dict[@"uid"] = [UserModel defaultUser].uid;
            dict[@"token"] = [UserModel defaultUser].token;
            dict[@"goods_id"] = self.goods_id;
            dict[@"address_id"] = self.address_id;
            dict[@"spec_id"] = self.goods_spec;
            dict[@"num"] = self.goods_count;
            dict[@"total_money"] = [NSString stringWithFormat:@"%f",_sumNum];
            dict[@"order_remark"] = self.remarkTextV.text;
            
            _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
            [NetworkManager requestPOSTWithURLStr:kMark_Pay_URL paramDic:dict finish:^(id responseObject) {

                [_loadV removeloadview];
                if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                    
                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                }else{
                    
                    [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                }

            } enError:^(NSError *error) {
                [_loadV removeloadview];

            }];
            
        }];
        
        [alertVC addAction:cancel];
        [alertVC addAction:ok];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{//普通商品
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"token"] = [UserModel defaultUser].token;
        dict[@"uid"] = [UserModel defaultUser].uid;
        dict[@"goods_id"] = self.goods_id;
        dict[@"num"] = self.goods_count;
        dict[@"address_id"] = self.address_id;
        dict[@"order_remark"] = self.remarkTextV.text;
        dict[@"total"] = [NSString stringWithFormat:@"%.4f",_sumNum];
        dict[@"c_type"] = @(self.orderType);
        dict[@"spec_id"] = self.goods_spec;
        
        _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kSUBMIT_ORDER_URL paramDic:dict finish:^(id responseObject) {
            
            [_loadV removeloadview];
            
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCartNotification" object:nil];
                
                self.hidesBottomBarWhenPushed = YES;
                
                GLMine_RicePayController *riceVC = [[GLMine_RicePayController alloc] init];
                
                riceVC.orderPrice = [NSString stringWithFormat:@"%f",_sumNum];
                riceVC.order_id = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_id"]];
                riceVC.order_sn = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"order_num"]];
                riceVC.orders_Price = responseObject[@"data"][@"order_money"];
                
                if (self.orderType == 0) {
                    riceVC.signIndex = 0;
                }else{
                    riceVC.signIndex = 2;
                }
                
                [self.navigationController pushViewController:riceVC animated:YES];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
        }];
    }
    
}

#pragma  UITableveiwdelegate UITableviewdatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GLOrderGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.models[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 117;
    
//    self.tableView.estimatedRowHeight = 44;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    return self.tableView.rowHeight;
    
}

#pragma mark uitextviewdelegete

-(void)textViewDidBeginEditing:(UITextView *)textView{

    if ([textView.text isEqualToString:@"这个买家什么也没留下!"]) {
        textView.text = @"";
    }

}

-(void)textViewDidEndEditing:(UITextView *)textView{

    NSString *string= [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (string.length <= 0) {
        textView.text = @"这个买家什么也没留下!";
    }

}

#pragma 懒加载
- (NSMutableArray *)models {
    if (_models == nil) {
        _models = [NSMutableArray array];
        
    }
    return _models;
}
@end
