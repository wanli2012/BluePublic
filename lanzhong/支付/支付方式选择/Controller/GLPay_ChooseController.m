//
//  GLPay_ChooseController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPay_ChooseController.h"
#import "GLPay_CompletedController.h"

@interface GLPay_ChooseController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *weixinSignImageV;
@property (weak, nonatomic) IBOutlet UIImageView *alipaySignImageV;
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
    self.weixinBtn.layer.borderWidth = 0.7f;
//    self.weixinBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.aliPayBtn.layer.cornerRadius = 5.f;
    self.aliPayBtn.layer.borderWidth = 0.7f;
//    self.aliPayBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    
    self.messageTextV.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.messageTextV.layer.borderWidth = 1.f;
    
    [self switchPay:self.weixinBtn];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//选择方式
- (IBAction)switchPay:(UIButton *)sender {
    
    self.weixinBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.5).CGColor;
    self.aliPayBtn.layer.borderColor = YYSRGBColor(184, 184, 184, 0.5).CGColor;
    
    sender.layer.borderColor = YYSRGBColor(170, 193, 255, 1).CGColor;
    
    if (sender == self.weixinBtn) {
        
        self.weixinSignImageV.hidden = NO;
        self.alipaySignImageV.hidden = YES;
    }else{
        
        self.weixinSignImageV.hidden = YES;
        self.alipaySignImageV.hidden = NO;
    }
    
}

//确认支付
- (IBAction)ensurePay:(id)sender {
    NSLog(@"确认支付");
    
    self.hidesBottomBarWhenPushed = YES;
    GLPay_CompletedController *completeVC = [[GLPay_CompletedController alloc] init];
    [self.navigationController pushViewController:completeVC animated:YES];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@"留言"]) {
        
        self.messageTextV.textColor = [UIColor darkGrayColor];
        self.messageTextV.text = @"";
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if ([self.messageTextV.text isEqualToString:@""]) {
        
        self.messageTextV.textColor = [UIColor lightGrayColor];
        self.messageTextV.text = @"留言";
        
    }
    return YES;
}

@end
