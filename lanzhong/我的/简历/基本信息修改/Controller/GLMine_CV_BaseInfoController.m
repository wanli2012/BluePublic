//
//  GLMine_CV_BaseInfoController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_BaseInfoController.h"

#import "GLMine_CV_LifeModel.h"
//单选picker 和动画
#import "editorMaskPresentationController.h"
#import "GLSimpleSelectionPickerController.h"//单项选择
#import "GLMutipleChooseController.h"//省市选择
#import "GLDatePickerController.h"//日期选择

@interface GLMine_CV_BaseInfoController ()<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UITextFieldDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;//性别
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;//学历
@property (weak, nonatomic) IBOutlet UILabel *workLifeLabel;//工作年限
@property (weak, nonatomic) IBOutlet UILabel *birthLabel;//出生年月日
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;//城市
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;//手机号码
@property (weak, nonatomic) IBOutlet UITextField *emailTF;//邮箱
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;//确定

@property (nonatomic, strong)NSMutableArray *lifeArr;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *lifeModels;//工作年限数据源
@property (nonatomic, strong)NSMutableArray *cityModels;//城市数据源
@property (nonatomic, copy)NSString *provinceId;//省份id
@property (nonatomic, copy)NSString *cityId;//城市id
@property (nonatomic, assign)NSInteger sexID;//性别id

@end

@implementation GLMine_CV_BaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基本信息";
    self.ensureBtn.layer.cornerRadius = 5.f;
    [self setOriginalValue];
    [self.nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)setOriginalValue{
    if (self.basicModel) {
        
        if (self.basicModel.name == 0) {

            self.cityLabel.text = @"请选择城市";
            self.educationLabel.text = @"请选择学历";
            self.workLifeLabel.text = @"请选择工作年限";
            self.birthLabel.text = @"请选择生日";
            self.sexLabel.text = @"请选择性别";
        }else{
           
            self.nameTF.text = self.basicModel.name;
            self.educationLabel.text = self.basicModel.education;
            self.workLifeLabel.text = self.basicModel.work;
            self.birthLabel.text = self.basicModel.birth_time;
            self.cityLabel.text = self.basicModel.city_name;
            
            self.sexLabel.textColor = [UIColor darkGrayColor];
            self.educationLabel.textColor = [UIColor darkGrayColor];
            self.workLifeLabel.textColor = [UIColor darkGrayColor];
            self.birthLabel.textColor = [UIColor darkGrayColor];
            self.cityLabel.textColor = [UIColor darkGrayColor];
            
            self.emailTF.text = self.basicModel.email;
            if ([self.basicModel.sex integerValue] == 1) {
                self.sexLabel.text = @"男";
            }else if([self.basicModel.sex integerValue] == 2){
                self.sexLabel.text = @"女";
            }else{
                self.sexLabel.text = @"";
            }
        }
        
        if ([self.basicModel.phone integerValue] == 0) {
            self.phoneNumTF.text = @"";
        }else{
            
            self.phoneNumTF.text = self.basicModel.phone;
        }
        
        self.sexID = [self.basicModel.sex integerValue];
        self.provinceId = self.basicModel.province_id;
        self.cityId = self.basicModel.city_id;
        
    }
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 500;
}
#pragma mark - 性别
- (IBAction)sexChoose:(id)sender {

    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
    [self popLifeChooser:dataArr andTitle:@"请选择性别" type:1];

}
#pragma mark - 学历
- (IBAction)educationChoose:(id)sender {
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"中专及以下",@"高中",@"大专",@"本科",@"硕士",@"博士"]];
 
    [self popLifeChooser:dataArr andTitle:@"请选择学历" type:2];

}
#pragma mark - 工作年限
- (IBAction)workLifeChoose:(id)sender {
    if (self.lifeModels.count != 0) {
        
        [self popLifeChooser:self.lifeArr andTitle:@"请选择工作年限" type:3];
        return;
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCV_LIFE_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.lifeModels removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLMine_CV_LifeModel *model = [GLMine_CV_LifeModel mj_objectWithKeyValues:dic];
                    [self.lifeModels addObject:model];
                }
                
                [self.lifeArr removeAllObjects];
                for (GLMine_CV_LifeModel *model in self.lifeModels) {
                    [self.lifeArr addObject:model.time];
                }
                [self popLifeChooser:self.lifeArr andTitle:@"请选择工作年限" type:3];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}
//type: 1:性别 2:学历 3:工作年限
- (void)popLifeChooser:(NSMutableArray *)dataArr andTitle:(NSString *)title type:(NSInteger)type {
    [self.view endEditing:YES];
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    vc.dataSourceArr = dataArr;
    
    vc.titlestr = title;
    
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        switch (type) {
            case 1:
            {
                weakSelf.sexLabel.text = dataArr[index];
                weakSelf.sexLabel.textColor = [UIColor darkGrayColor];
                if (index == 0) {
                    self.sexID = 1;
                }else{
                    self.sexID = 2;
                }
            }
                break;
            case 2:
            {
                weakSelf.educationLabel.text = dataArr[index];
                weakSelf.educationLabel.textColor = [UIColor darkGrayColor];
            }
                break;
            case 3:
            {
                
                weakSelf.workLifeLabel.text = dataArr[index];
                weakSelf.workLifeLabel.textColor = [UIColor darkGrayColor];
            }
                break;
                
            default:
                break;
        }
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - 生日
- (IBAction)birthChoose:(id)sender {
    [self.view endEditing:YES];
    
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.birthLabel.text = dateStr;
       weakSelf.birthLabel.textColor = [UIColor darkGrayColor];
    };

    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}

#pragma mark - 城市选择
- (IBAction)cityChoose:(id)sender {
    
    if (self.cityModels.count != 0) {
        [self popCityChoose];
        return;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCITYLIST_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.cityModels removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    GLPublish_CityModel *model = [GLPublish_CityModel mj_objectWithKeyValues:dic];
                    [self.cityModels addObject:model];
                }
                [self popCityChoose];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];

}
- (void)popCityChoose{
    
    [self.view endEditing:YES];
    GLMutipleChooseController *vc=[[GLMutipleChooseController alloc]init];
    vc.dataArr = self.cityModels;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        weakself.cityLabel.text = str;
        weakself.provinceId = provinceid;
        weakself.cityId = cityd;
        weakself.cityLabel.textColor = [UIColor darkGrayColor];
    };
}

#pragma mark -保存
- (IBAction)save:(id)sender {
  
    if(self.nameTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if(self.sexLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    if(self.educationLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择学历"];
        return;
    }
    if(self.workLifeLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择工作年限"];
        return;
    }
    if(self.birthLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择出生日期"];
        return;
    }
    if(self.cityLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择城市"];
        return;
    }
  
    if (![predicateModel valiMobile:self.phoneNumTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"手机号码输入有误"];
        return;
    }
    
    if (![predicateModel isValidateEmail:self.emailTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"邮箱输入有误"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"name"] = self.nameTF.text;
    dic[@"sex"] = @(self.sexID);
    dic[@"education"] = self.educationLabel.text;
    dic[@"work"] = self.workLifeLabel.text;
    dic[@"birth_time"] = self.birthLabel.text;
    dic[@"phone"] = self.phoneNumTF.text;
    dic[@"email"] = self.emailTF.text;
    dic[@"province_id"] = self.provinceId;
    dic[@"city_id"] = self.cityId;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMODIFY_BASEINFO_URL paramDic:dic finish:^(id responseObject) {
        
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.nameTF) {
        [self.phoneNumTF becomeFirstResponder];
    }else if(textField == self.phoneNumTF){
        [self.emailTF becomeFirstResponder];
    }else{
        [self.emailTF resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.nameTF) {
        if (textField.text.length > 16) {
            textField.text = [textField.text substringToIndex:16];
        }
    }
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

#pragma mark - 动画的代理
//动画
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
    
    
    [self chooseindustry:transitionContext];
    
    
}
-(void)chooseindustry:(id <UIViewControllerContextTransitioning>)transitionContext{
    
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


- (NSMutableArray *)cityModels{
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    return _cityModels;
}//lifeModels

- (NSMutableArray *)lifeModels{
    if (!_lifeModels) {
        _lifeModels = [NSMutableArray array];
    }
    return _lifeModels;
}

- (NSMutableArray *)lifeArr{
    if (!_lifeArr) {
        _lifeArr = [NSMutableArray array];
    }
    return _lifeArr;
}
@end
