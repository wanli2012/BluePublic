//
//  GLMine_WalletController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletController.h"
#import "GLMine_WalletDetailController.h"//明细
#import "GLMine_AddCardController.h"//添加银行卡
#import "GLMine_WalletCardChooseController.h"//选择银行卡

@interface GLMine_WalletController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIButton *ensurePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureExchangeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *addImageV;
@property (weak, nonatomic) IBOutlet UILabel *addCardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@property (nonatomic, copy)NSString *bankName;//银行名字
@property (nonatomic, copy)NSString *bankNum;//银行卡号
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *exchangeTextF;//兑换金额
@property (nonatomic, assign)BOOL isHaveDian;

@end

@implementation GLMine_WalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"钱包";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    self.topBgView.layer.cornerRadius = 5.f;
    
    self.topBgView.layer.shadowOpacity = 0.2f;
    self.topBgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.topBgView.layer.shadowRadius = 2.f;
    
    self.ensurePayBtn.layer.cornerRadius = 5.f;
    self.ensureExchangeBtn.layer.cornerRadius = 5.f;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [btn setTitle:@"明细" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
 
}
//是否隐藏
- (void)isHiddenTheAddImage:(BOOL)isHidden{
    
    self.addImageV.hidden = isHidden;
    self.addCardLabel.hidden = isHidden;
    
    self.bankIconImageV.hidden = !isHidden;
    self.bankNameLabel.hidden = !isHidden;
    self.bankNumLabel.hidden = !isHidden;
    self.arrowImageV.hidden = !isHidden;
    
    self.bankNameLabel.text = self.bankName;
    self.bankNumLabel.text = self.bankNum;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.bankName == nil || self.bankNum == nil) {
        [self isHiddenTheAddImage:NO];
    }else{
        [self isHiddenTheAddImage:YES];
    }
    
    self.navigationController.navigationBar.hidden = NO;
}
//明细
- (void)detail{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_WalletDetailController *detailVC = [[GLMine_WalletDetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}


- (IBAction)switchFunc:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        
        self.rechargeView.hidden = YES;
    
    }else if (sender.selectedSegmentIndex == 1){
        
        self.rechargeView.hidden = NO;
    }
    
}

//添加银行卡
- (IBAction)addCard:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddCardController *addVC = [[GLMine_AddCardController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

//选择银行卡
- (IBAction)chooseCard:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_WalletCardChooseController *cardChooseVC = [[GLMine_WalletCardChooseController alloc] init];
    
    cardChooseVC.block = ^(NSString *bankName,NSString *bankNum){
        self.bankName = bankName;
        self.bankNum = bankNum;
        [self isHiddenTheAddImage:YES];
    };
    
    [self.navigationController pushViewController:cardChooseVC animated:YES];
}

#pragma mark - UITextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == self.moneyTextF) {
        [self.passwordTextF becomeFirstResponder];
    }else if(textField == self.passwordTextF){
        [self.passwordTextF resignFirstResponder];
    }else if(textField == self.exchangeTextF){
        [self.exchangeTextF resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.moneyTextF || textField == self.exchangeTextF) {
        /*
         * 不能输入.0-9以外的字符。
         * 设置输入框输入的内容格式
         * 只能有一个小数点
         * 小数点后最多能输入两位
         * 如果第一位是.则前面加上0.
         * 如果第一位是0则后面必须输入点，否则不能输入。
         */
        
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        
        if (string.length > 0) {
            
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.'))
            {
                [MBProgressHUD showError:@"您的输入格式不正确"];
                return NO;
            }
            
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') {
                [MBProgressHUD showError:@"最多只能输入一个小数点"];
                return NO;
            }
            
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }else{
                    if (![string isEqualToString:@"."]) {
                        [MBProgressHUD showError:@"第二个字符需要是小数点"];
                        return NO;
                    }
                }
            }
            
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) {
                        [MBProgressHUD showError:@"小数点后最多有两位小数"];
                        return NO;
                    }
                }
            }
            
        }
    }
    
    return YES;

}

@end
