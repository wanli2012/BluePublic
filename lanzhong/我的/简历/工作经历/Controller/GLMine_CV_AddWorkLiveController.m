//
//  GLMine_CV_AddWorkLiveController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/20.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_AddWorkLiveController.h"

//单选picker 和动画
#import "editorMaskPresentationController.h"
#import "GLDatePickerController.h"//日期选择

@interface GLMine_CV_AddWorkLiveController ()<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *positionTF;
@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;

@property (nonatomic, copy)NSString *live_id;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_CV_AddWorkLiveController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == 1) {
        self.navigationItem.title = @"编辑工作经历";
    }else{
        
        self.navigationItem.title = @"添加工作经历";
    }
    self.ensureBtn.layer.cornerRadius = 5.f;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 500;


    [self setOriginal];
}

- (void)setOriginal {
    if(self.model){
        
        self.nameTF.text = self.model.company_name;
        self.positionTF.text = self.model.career_name;
        self.contentTV.text = self.model.work_content;
        self.contentTV.textColor = [UIColor blackColor];
        
        NSArray *array;
        if(self.model.work_time.length != 0){
            array = [self.model.work_time componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
        }
        self.startTimeLabel.text = array.firstObject;
        self.endTimeLabel.text = array.lastObject;
        
        self.live_id = self.model.live_id;
    }
}

- (IBAction)startTimeChoose:(id)sender {
    [self.view endEditing:YES];
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择入职日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.startTimeLabel.text = dateStr;
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)endTimeChoose:(id)sender {
    [self.view endEditing:YES];
    GLDatePickerController *vc=[[GLDatePickerController alloc]init];
    vc.titleLabel.text = @"请选择结束日期";
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSString *dateStr){
        weakSelf.endTimeLabel.text = dateStr;
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - 添加
- (IBAction)submit:(id)sender {
    if(self.nameTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入公司名称"];
        return;
    }
    if(self.positionTF.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入职位名称"];
        return;
    }
    if(self.startTimeLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择入职时间"];
        return;
    }
    if(self.endTimeLabel.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择结束时间"];
        return;
    }
    if(self.contentTV.text.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请输入工作内容"];
        return;
    }

    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSDate *dateStart = [formater dateFromString:self.startTimeLabel.text];
    NSDate *dateEnd = [formater dateFromString:self.endTimeLabel.text];
    
    if ([self compareOneDay:dateStart withAnotherDay:dateEnd] != -1) {
        [SVProgressHUD showErrorWithStatus:@"结束日期不能小于开始日期"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"company_name"] = self.nameTF.text;
    dic[@"career_name"] = self.positionTF.text;
    dic[@"work_time"] = [NSString stringWithFormat:@"%@-%@",self.startTimeLabel.text,self.endTimeLabel.text];
    dic[@"work_content"] = self.contentTV.text;
    if (self.live_id.length == 0) {
        
        dic[@"live_id"] = @"0";
    }else{
        dic[@"live_id"] = self.live_id;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_ADD_WORKLIFE_URL paramDic:dic finish:^(id responseObject) {
        
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
#pragma mark - UITextFieldDelegate UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTF) {
        [self.positionTF becomeFirstResponder];
    }else if(textField == self.positionTF){
        [self.contentTV becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"请输入工作内容"]) {
        self.contentTV.text = @"";
        self.contentTV.textColor = [UIColor blackColor];
    }
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        
        self.contentTV.text = @"请输入工作内容";
        self.contentTV.textColor = [UIColor lightGrayColor];
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
