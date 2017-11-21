//
//  GLMine_CV_ExpectedWorkController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/11/21.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_CV_ExpectedWorkController.h"
#import "GLMine_CV_CareerModel.h"
#import "GLPublish_CityModel.h"

//单选picker 和动画
#import "editorMaskPresentationController.h"
#import "GLSimpleSelectionPickerController.h"//单项选择
#import "GLMutipleChooseController.h"//省市选择

@interface GLMine_CV_ExpectedWorkController ()<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
{
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray <GLMine_CV_CareerModel *>*careerModels;//职业数据源
@property (nonatomic, strong)NSMutableArray <GLMine_CV_CareerModel *>*moneyModels;//期望薪资数据源
@property (nonatomic, strong)NSMutableArray *cityModels;//城市数据源

@property (nonatomic, strong)NSMutableArray *careerArr;
@property (nonatomic, strong)NSMutableArray *moneyArr;

@property (nonatomic, copy)NSString *career_id;//职业id
@property (nonatomic, copy)NSString *money;//职业id
@property (nonatomic, copy)NSString *provinceId;//省份id
@property (nonatomic, copy)NSString *cityId;//城市id

@end

@implementation GLMine_CV_ExpectedWorkController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"期望工作";
    [self setOriginalValue];//赋初始值
}

- (void)setOriginalValue{
    
    if (self.model) {
        self.positionLabel.text = self.model.want_duty;
        self.cityLabel.text = [NSString stringWithFormat:@"%@%@",self.model.want_province_name,self.model.want_city_name];
        self.moneyLabel.text = self.model.want_wages;
        self.provinceId = self.model.want_province_id;
        self.cityId = self.model.want_city_id;
    }
}

#pragma mark - 确定
- (IBAction)ensure:(id)sender {
    
    if (self.moneyLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择期望薪资"];
        return;
    }
    if(self.provinceId.length == 0 || self.cityId.length == 0){
        [SVProgressHUD showErrorWithStatus:@"请选择期望城市"];
        return;
    }
    if (self.positionLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择职业"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"duty"] = self.positionLabel.text;
    dic[@"want_province"] = self.provinceId;
    dic[@"want_city"] = self.cityId;
    dic[@"want_wages"] = self.money;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCV_WANT_WORK_URL paramDic:dic finish:^(id responseObject) {
        
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
#pragma mark - 职业选择
- (IBAction)positionChoose:(id)sender {
    
    if (self.careerArr.count != 0) {
        [self popChooser:self.careerArr Title:@"请选择职业" andIsCareer:YES];
        return;
    }
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCV_CAREER_LIST_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                [self.careerModels removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_CV_CareerModel *model = [GLMine_CV_CareerModel mj_objectWithKeyValues:dic];
                    [self.careerModels addObject:model];
                }
                [self.careerArr removeAllObjects];
                for (GLMine_CV_CareerModel *model in self.careerModels) {
                    [self.careerArr addObject:model.name];
                }
                [self popChooser:self.careerArr Title:@"请选择职业" andIsCareer:YES];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

#pragma mark - 薪资选择
- (IBAction)moneyChoose:(id)sender {
    
    if (self.moneyModels.count != 0) {
        [self popChooser:self.moneyArr Title:@"请选择期望薪资" andIsCareer:NO];
        return;
    }
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kCV_MONEY_URL paramDic:@{} finish:^(id responseObject) {
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                [self.moneyModels removeAllObjects];
                for (NSDictionary *dic in responseObject[@"data"]) {
                    GLMine_CV_CareerModel *model = [GLMine_CV_CareerModel mj_objectWithKeyValues:dic];
                    [self.moneyModels addObject:model];
                }
                [self.moneyArr removeAllObjects];
                for (GLMine_CV_CareerModel *model in self.moneyModels) {
                    [self.moneyArr addObject:model.name];
                }
                [self popChooser:self.moneyArr Title:@"请选择期望薪资" andIsCareer:NO];
            }
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
    }];
}

#pragma mark - 弹出单项选择器
- (void)popChooser:(NSMutableArray *)dataArr Title:(NSString *)title andIsCareer:(BOOL)isCareer{
    
    GLSimpleSelectionPickerController *vc=[[GLSimpleSelectionPickerController alloc]init];
    vc.dataSourceArr = dataArr;
    vc.titlestr = title;
    __weak typeof(self)weakSelf = self;
    vc.returnreslut = ^(NSInteger index){
        
        if (isCareer) {
            weakSelf.positionLabel.text = dataArr[index];
            weakSelf.career_id = self.careerModels[index].id;
        }else{
            weakSelf.moneyLabel.text = dataArr[index];
            weakSelf.money = dataArr[index];
        }
    };
    
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - 弹出城市选择器
- (void)popCityChoose{
    
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
    };
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

#pragma mark - 懒加载
- (NSMutableArray *)careerModels{
    if (!_careerModels) {
        _careerModels = [NSMutableArray array];
    }
    return _careerModels;
}
- (NSMutableArray *)cityModels{
    if (!_cityModels) {
        _cityModels = [NSMutableArray array];
    }
    return _cityModels;
}
- (NSMutableArray *)moneyModels{
    if (!_moneyModels) {
        _moneyModels = [NSMutableArray array];
    }
    return _moneyModels;
}
- (NSMutableArray *)careerArr{
    if (!_careerArr) {
        _careerArr = [NSMutableArray array];
    }
    return _careerArr;
}
- (NSMutableArray *)moneyArr{
    if (!_moneyArr) {
        _moneyArr = [NSMutableArray array];
    }
    return _moneyArr;
}
@end
