//
//  GLTrain_SignUpController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLTrain_SignUpController.h"
//单选picker 和动画
#import "editorMaskPresentationController.h"
#import "GLSimpleSelectionPickerController.h"//单项选择

@interface GLTrain_SignUpController ()<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}

@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *educationTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, copy)NSString *sex_id;//用户性别 1男 2女

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLTrain_SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.ensureBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"报名";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT - 64;
}

#pragma mark - 确定
- (IBAction)sure:(id)sender {
    
    if(self.train_id.length == 0){
        [SVProgressHUD showErrorWithStatus:@"培训班未选择"];
        return;
    }
    if(self.nameTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if(self.sex_id.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择性别"];
        return;
    }
    if(self.educationTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入学历"];
        return;
    }
    if(![predicateModel valiMobile:self.phoneTF.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"train_id"] = self.train_id;
    dic[@"name"] = self.nameTF.text;
    dic[@"enrol_xl"] = self.educationTF.text;
    dic[@"phone"] = self.phoneTF.text;
    dic[@"sex"] = self.sex_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kTrain_Enroll_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [SVProgressHUD showSuccessWithStatus:@"报名成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
      
    }];
}

#pragma mark - 学历选择
- (IBAction)educationChoose:(id)sender {
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"中专及以下",@"高中",@"大专",@"本科",@"硕士",@"博士"]];
    
    [self popChooser:dataArr andTitle:@"请选择学历" type:2];
    
}

#pragma mark - 性别选择
- (IBAction)sexChoose:(id)sender {
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"男",@"女"]];
    [self popChooser:dataArr andTitle:@"请选择性别" type:1];
}

//type: 1:性别
- (void)popChooser:(NSMutableArray *)dataArr andTitle:(NSString *)title type:(int)type {
    [self.view endEditing:YES];
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    vc.dataSourceArr = dataArr;
    
    vc.titlestr = title;
    
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        switch (type) {
            case 1:
                {
                    NSInteger sex = index + 1;
                    weakSelf.sex_id = [NSString stringWithFormat:@"%ld",(long)sex];
                    
                    if(index == 0){
                        weakSelf.sexTF.text = @"男";
                    }else{
                        weakSelf.sexTF.text = @"女";
                    }
                }
                break;
            case 2:
            {
                weakSelf.educationTF.text = dataArr[index];
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



@end
