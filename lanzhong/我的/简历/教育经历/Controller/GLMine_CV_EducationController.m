//
//  GLMine_CV_EducationController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_EducationController.h"

//单选picker 和动画
#import "editorMaskPresentationController.h"
#import "GLDatePickerController.h"//日期选择
#import "GLSimpleSelectionPickerController.h"

@interface GLMine_CV_EducationController ()<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UITextFieldDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *majorTF;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_CV_EducationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"教育经历";
    
    self.ensureBtn.layer.cornerRadius = 5.f;
    [self setOriginalValue];
}

- (void)setOriginalValue{
    
    if (self.model) {
        self.nameTF.text = self.model.school;
        self.majorTF.text = self.model.major;
        self.educationLabel.text = self.model.education_leave;
        
        NSArray *array;
        if(self.model.leave_time.length != 0){
            array = [self.model.leave_time componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        }
        self.startTimeLabel.text = array.firstObject;
        self.endTimeLabel.text = array.lastObject;
    }

}

#pragma mark - 学历选择
- (IBAction)educationChoose:(id)sender {
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:@[@"中专及以下",@"高中",@"大专",@"本科",@"硕士",@"博士"]];
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

#pragma mark - 入学时间选择
- (IBAction)startTimeChoose:(id)sender {
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择入学日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.startTimeLabel.text = dateStr;
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - 毕业时间选择
- (IBAction)endTimeChoose:(id)sender {
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择毕业日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.endTimeLabel.text = dateStr;
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}
#pragma mark - 保存
- (IBAction)ensure:(id)sender {
    if(self.nameTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入学校名字"];
        return;
    }
    if(self.majorTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入专业名字"];
        return;
    }
    if(self.educationLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择学历"];
        return;
    }
    if(self.startTimeLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择入学时间"];
        return;
    }
    if(self.endTimeLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择毕业时间"];
        return;
    }
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSDate *dateStart = [formater dateFromString:self.startTimeLabel.text];
    NSDate *dateEnd = [formater dateFromString:self.endTimeLabel.text];
    if ([self compareOneDay:dateStart withAnotherDay:dateEnd] != -1) {
        [SVProgressHUD showErrorWithStatus:@"结束日期应晚于开始日期"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"school"] = self.nameTF.text;
    dic[@"major"] = self.majorTF.text;
    dic[@"leave_time"] = [NSString stringWithFormat:@"%@-%@",self.startTimeLabel.text,self.endTimeLabel.text];
    dic[@"education_leave"] = self.educationLabel.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_MODIFY_EDU_URL paramDic:dic finish:^(id responseObject) {
        
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
#pragma mark - 时间比较大小
- (NSInteger )compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //oneDay > anotherDay
        return 1;
    }
    else if (result == NSOrderedAscending){
        //oneDay < anotherDay
        return -1;
    }
    //oneDay = anotherDay
    return 0;
}
#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTF) {
        [self.majorTF becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
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
