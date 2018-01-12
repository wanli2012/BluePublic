//
//  GLMine_AddCardController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AddCardController.h"
#import "GLSet_MaskVeiw.h"
#import "GLBuyBackChooseBankView.h"
#import "GLMine_BankNameModel.h"
#import "GLSimpleSelectionPickerController.h"
#import "editorMaskPresentationController.h"


@interface GLMine_AddCardController ()<UINavigationControllerDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>
{
    UIView *_maskV;
    GLBuyBackChooseBankView *_contentV;
    BOOL _ishidecotr;//判断是否隐藏弹出控制器
}
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)NSMutableArray *bankNameModels;

@end

@implementation GLMine_AddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"添加银行卡";
    self.ensureBtn.layer.cornerRadius = 5.f;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];

    self.nameTF.text = [UserModel defaultUser].truename;
    self.nameTF.enabled = NO;
    [self getPickerData];

}
#pragma mark - get data
- (void)getPickerData {
    //银行列表
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kBANK_NAMELIST_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                GLMine_BankNameModel *model = [GLMine_BankNameModel mj_objectWithKeyValues:dic];
                [self.bankNameModels addObject:model];
            }
       
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];

}
- (IBAction)bankCardChoose:(id)sender {
    
    GLSimpleSelectionPickerController *vc = [[GLSimpleSelectionPickerController alloc]init];
    
    if (self.bankNameModels.count > 0) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (GLMine_BankNameModel *model in self.bankNameModels) {
            [arr addObject:model.bank_name];
        }
        
        vc.dataSourceArr = arr;
        vc.titlestr = @"请选择银行";
        
        typeof(self)weakSelf = self;
        vc.returnreslut = ^(NSInteger index){
            
            GLMine_BankNameModel *model = weakSelf.bankNameModels[index];
            weakSelf.bankNameTF.text = model.bank_name;
            
        };
        
        vc.transitioningDelegate = self;
        vc.modalPresentationStyle=UIModalPresentationCustom;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
    }

    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.3 animations:^{
        _maskV.alpha = 0;
        _contentV.alpha = 0;
    } completion:^(BOOL finished) {
        [_maskV removeFromSuperview];
        [_contentV removeFromSuperview];
        
    }];
}
- (IBAction)ensure:(id)sender {
    
    if (self.cardNumTF.text.length < 14 || self.cardNumTF.text.length > 21){
        [SVProgressHUD showErrorWithStatus:@"银行卡输入不合法"];
        return;
    }
    if ([predicateModel checkIsHaveNumAndLetter:self.cardNumTF.text] != 1) {
        [SVProgressHUD showErrorWithStatus:@"银行卡号只能是数字"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"name"] = self.nameTF.text;
    dict[@"bank_num"] = self.cardNumTF.text;
    dict[@"bank_name"] = self.bankNameTF.text;
    dict[@"bank_branch"] = self.addressTF.text;
    dict[@"is_default"] = @(self.switchBtn.on);
    
    _loadV=[LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:[UIApplication sharedApplication].keyWindow];
    [NetworkManager requestPOSTWithURLStr:kADD_BANK_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addCardNotification" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
            
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        
    }];
    
}

#pragma mark - 动画代理
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

- (NSMutableArray *)bankNameModels{
    if (!_bankNameModels) {
        _bankNameModels = [NSMutableArray array];
    }
    return _bankNameModels;
}
@end
