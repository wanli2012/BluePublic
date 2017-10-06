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


@interface GLMine_AddCardController ()
{
    UIView *_maskV;
    GLBuyBackChooseBankView *_contentV;
}
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation GLMine_AddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"添加银行卡";
    self.ensureBtn.layer.cornerRadius = 5.f;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:@"maskView_dismiss" object:nil];


}

- (IBAction)bankCardChoose:(id)sender {
    NSLog(@"选择银行");
//    _maskV = [[GLSet_MaskVeiw alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
//    _maskV.bgView.alpha = 0.3;
    _maskV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _maskV.backgroundColor = [UIColor blackColor];
    _maskV.alpha = 0.3;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_maskV addGestureRecognizer:tap];
    
    _contentV = [[NSBundle mainBundle] loadNibNamed:@"GLBuyBackChooseBankView" owner:nil options:nil].lastObject;
    
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.bankNameTF convertRect: self.bankNameTF.bounds toView:window];
    
    _contentV.frame = CGRectMake(20,CGRectGetMaxY(rect) + 10, kSCREEN_WIDTH - 40, kSCREEN_HEIGHT * 0.5);
    
    __weak __typeof(self)weakSelf = self;
    _contentV.block = ^(NSString *str){
        weakSelf.bankNameTF.text = str;
        [weakSelf dismiss];
    };
    
    _contentV.backgroundColor = [UIColor whiteColor];
    _contentV.layer.cornerRadius = 4;
    _contentV.layer.masksToBounds = YES;
    
//    [_maskV showViewWithContentView:_contentV];
    
    [window addSubview:_maskV];
    [window addSubview:_contentV];
    
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
    NSLog(@"确定");
}

@end
