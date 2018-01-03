//
//  GLMine_EvaluatingController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/18.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_EvaluatingController.h"

@interface GLMine_EvaluatingController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textV;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *specLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

@implementation GLMine_EvaluatingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论页面";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.submitBtn.layer.cornerRadius = 5.f;
    
    NSString *imageStr = [NSString stringWithFormat:@"%@?imageView2/1/w/300/h/300",self.model.must_thumb];
    [self.picImageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.titleLabel.text = self.model.goods_name;
    self.specLabel.text = self.model.title;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (IBAction)submit:(id)sender {
    
    if([self.textV.text isEqualToString:@"请留下您的真实感受"] || self.textV.text.length == 0){
        [MBProgressHUD showError:@"请填写评论"];
        return ;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"og_id"] = self.model.og_id;
    dict[@"goods_id"] = self.model.goods_id;
    dict[@"comment"] = self.textV.text;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kCOMMENT_GOODS_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            [MBProgressHUD showSuccess:responseObject[@"message"]];
            self.block();
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [MBProgressHUD showError:responseObject[@"message"]];

    } enError:^(NSError *error) {
        [_loadV removeloadview];

    }];
    
    
}


#pragma mark - UITextViewDelegate textViewShouldBeginEditing
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    if([textView.text isEqualToString:@"请留下您的真实感受"]){
        self.textV.text = @"";
        self.textV.textAlignment = NSTextAlignmentLeft;
        self.textV.textColor = [UIColor darkGrayColor];
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    if (self.textV.text.length == 0) {
        self.textV.text = @"请留下您的真实感受";
        self.textV.textAlignment = NSTextAlignmentCenter;
        self.textV.textColor = [UIColor lightGrayColor];
    }
    
    return YES;
}

@end
