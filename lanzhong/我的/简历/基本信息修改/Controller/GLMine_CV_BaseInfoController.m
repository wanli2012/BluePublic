//
//  GLMine_CV_BaseInfoController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_BaseInfoController.h"

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

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *cityModels;//城市数据源
@property (nonatomic, copy)NSString *provinceId;//省份id
@property (nonatomic, copy)NSString *cityId;//城市id

@end

@implementation GLMine_CV_BaseInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"基本信息";
    self.ensureBtn.layer.cornerRadius = 5.f;
    [self setOriginalValue];
    
}

- (void)setOriginalValue{
    if (self.basicModel) {
        
        self.nameTF.text = self.basicModel.name;
        self.sexLabel.text = self.basicModel.sex;
        self.educationLabel.text = self.basicModel.education;
        self.workLifeLabel.text = self.basicModel.work;
        self.birthLabel.text = self.basicModel.birth_time;
        self.cityLabel.text = self.basicModel.city_name;
        self.phoneNumTF.text = self.basicModel.phone;
        self.emailTF.text = self.basicModel.email;
    }
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 500;
}

- (IBAction)sexChoose:(id)sender {

    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
    vc.dataSourceArr = dataArr;
    
    vc.titlestr = @"请选择性别";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        weakSelf.sexLabel.text = dataArr[index];

    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)educationChoose:(id)sender {
 
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"高中",@"大专",@"本科",@"研究生"]];
    vc.dataSourceArr = dataArr;
    
    vc.titlestr = @"请选择学历";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        weakSelf.educationLabel.text = dataArr[index];
        
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
- (IBAction)workLifeChoose:(id)sender {
   
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"1年",@"2年",@"10年以上"]];
    vc.dataSourceArr = dataArr;
    
    vc.titlestr = @"请选择工作年限";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        weakSelf.workLifeLabel.text = dataArr[index];
        
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)birthChoose:(id)sender {
    
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.birthLabel.text = dateStr;
    };

    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}

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
    
    GLMutipleChooseController *vc=[[GLMutipleChooseController alloc]init];
    vc.dataArr = self.cityModels;
    vc.transitioningDelegate=self;
    vc.modalPresentationStyle=UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    __weak typeof(self) weakself = self;
    vc.returnreslut = ^(NSString *str,NSString *strid,NSString *provinceid,NSString *cityd,NSString *areaid){
        //                weakself.cityLabel.textColor = [UIColor darkGrayColor];
        weakself.cityLabel.text = str;
        weakself.provinceId = provinceid;
        weakself.cityId = cityd;
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
    dic[@"sex"] = self.sexLabel.text;
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField == self.phoneNumTF){
       return [self validateNumber:string];
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
}
@end
