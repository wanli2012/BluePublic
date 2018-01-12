//
//  GLMine_AddressAddController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/7.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AddressAddController.h"
#import "LBMineCenterChooseAreaViewController.h"//省市区选择
#import "editorMaskPresentationController.h"

@interface GLMine_AddressAddController ()<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    BOOL      _ishidecotr;//判断是否隐藏弹出控制器
}

@property (strong, nonatomic)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (strong, nonatomic)NSString *adressID;
@property (strong, nonatomic)NSString *provinceStrId;
@property (strong, nonatomic)NSString *cityStrId;
@property (strong, nonatomic)NSString *countryStrId;

@property (assign, nonatomic)NSInteger  isdeualt;//默认为0 不设为默认
@property (weak, nonatomic) IBOutlet UIImageView *isDefaultImage;
@property (weak, nonatomic) IBOutlet UIImageView *isdeualtImageOne;

@end

@implementation GLMine_AddressAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增收货地址";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //导航栏右键
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(ensure) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.isdeualt = 0;
    
    [self getPickerData];
    [self updateInfo];
    
}

- (void)updateInfo{
    if (self.isEdit) {
        
        self.nameTF.text = self.model.collect_name;
        self.phoneTF.text = self.model.phone;
        self.detailAddressTF.text = self.model.address;
        self.addressTF.text = [NSString stringWithFormat:@"%@%@%@",self.model.province_name,self.model.city_name,self.model.area_name];
        
        if ([self.model.is_default integerValue] == 0) {
            
            self.isDefaultImage.image = [UIImage imageNamed:@"address_choice"];
            self.isdeualtImageOne.image = [UIImage imageNamed:@"address_nochoice"];
        }else{
            self.isDefaultImage.image = [UIImage imageNamed:@"address_nochoice"];
            self.isdeualtImageOne.image = [UIImage imageNamed:@"address_choice"];
        }
        
        self.provinceStrId = self.model.province;
        self.cityStrId = self.model.city;
        self.countryStrId = self.model.area;
    }
}

#pragma mark - 城市列表
- (void)getPickerData {
    //城市列表
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCITYLIST_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            self.dataArr = responseObject[@"data"];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
}

- (IBAction)setupEventNot:(id)sender {
    self.isdeualt = 0;
    self.isDefaultImage.image = [UIImage imageNamed:@"address_choice"];
    self.isdeualtImageOne.image = [UIImage imageNamed:@"address_nochoice"];
}
- (IBAction)setupEventYes:(id)sender {
    self.isdeualt =1;
    self.isDefaultImage.image = [UIImage imageNamed:@"address_nochoice"];
    self.isdeualtImageOne.image = [UIImage imageNamed:@"address_choice"];
}

- (void)ensure{

    if (self.nameTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人姓名"];
        return;
    }
    if (self.phoneTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入电话号码"];
        return;
    }
    if (![predicateModel valiMobile:self.phoneTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的电话号码"];
        return;
    }
    if (self.addressTF.text.length <= 0) {
       [SVProgressHUD showErrorWithStatus:@"请输入省市区"];
        return;
    }
    if (self.detailAddressTF.text.length <= 0) {
        [SVProgressHUD showErrorWithStatus:@"请输入详细地址"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"collect_name"] = self.nameTF.text;
    dic[@"address"] = self.detailAddressTF.text;
    dic[@"phone"] = self.phoneTF.text;
    dic[@"is_default"] = @(self.isdeualt);
    dic[@"province"] = self.provinceStrId;
    dic[@"city"] = self.cityStrId;
    dic[@"area"] = self.countryStrId;

    
    if (self.isEdit == YES) {//编辑address_id
        
        dic[@"address_id"] = self.model.address_id;
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kUPDATE_ADDRESS_URL paramDic:dic finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            
        }];
        
    }else{//添加
        
        _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
        [NetworkManager requestPOSTWithURLStr:kADD_ADDRESS_URL paramDic:dic finish:^(id responseObject) {
            [_loadV removeloadview];
            if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshReceivingAddress" object:nil];
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
                
            }
        } enError:^(NSError *error) {
            [_loadV removeloadview];
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            
        }];
    }
}

#pragma mark - 省市区选择
- (IBAction)provincesChoose:(id)sender {
    
    LBMineCenterChooseAreaViewController *vc=[[LBMineCenterChooseAreaViewController alloc]init];
    
    vc.dataArr = self.dataArr;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.adressID = strid;
        weakself.addressTF.text = str;
        weakself.provinceStrId = provinceid;
        weakself.cityStrId = cityd;
        weakself.countryStrId = areaid;
    };
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    
    return [[editorMaskPresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    
}

//控制器创建执行的动画（返回一个实现UIViewControllerAnimatedTransitioning协议的类）
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _ishidecotr=YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _ishidecotr=NO;
    return self;
}
- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    return 0.5;
    
}
-(void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (_ishidecotr==YES) {
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.frame=CGRectMake(-kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
        toView.layer.cornerRadius = 6;
        toView.clipsToBounds = YES;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            
        }];
    }else{
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            toView.frame=CGRectMake(20 + kSCREEN_WIDTH, (kSCREEN_HEIGHT - 300)/2, kSCREEN_WIDTH - 40, 280);
            
        } completion:^(BOOL finished) {
            if (finished) {
                [toView removeFromSuperview];
                [transitionContext completeTransition:YES]; //这个必须写,否则程序 认为动画还在执行中,会导致展示完界面后,无法处理用户的点击事件
            }
        }];
    }
}

@end
