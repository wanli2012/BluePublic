//
//  GLPay_ChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_ChooseController.h"

@interface GLPay_ChooseController ()

@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;//微信支付
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;//支付宝支付
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextView *messageTextV;//留言textView

@end

@implementation GLPay_ChooseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"支付详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.ensureBtn.layer.cornerRadius = 5.f;
    
    self.weixinBtn.layer.cornerRadius = 5.f;
    self.weixinBtn.layer.borderWidth = 1.f;
    self.weixinBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.aliPayBtn.layer.cornerRadius = 5.f;
    self.aliPayBtn.layer.borderWidth = 1.f;
    self.aliPayBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.messageTextV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.messageTextV.layer.borderWidth = 1.f;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

//确认支付
- (IBAction)ensurePay:(id)sender {
    NSLog(@"确认支付");
}

@end
