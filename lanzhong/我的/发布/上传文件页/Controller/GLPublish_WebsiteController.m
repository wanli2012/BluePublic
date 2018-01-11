//
//  GLPublish_WebsiteController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/2.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_WebsiteController.h"
#import "GLMineController.h"

@interface GLPublish_WebsiteController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UILabel *linkLabel;//链接Label
@property (weak, nonatomic) IBOutlet UIButton *linkCopyBtn;//复制链接
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;//已上传
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;//注意事项

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)NodataView *nodataV;

@end

@implementation GLPublish_WebsiteController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
       
    }
    
    self.contentHeight.constant = 680;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
    self.linkCopyBtn.layer.cornerRadius = 5.f;
    self.linkCopyBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.linkCopyBtn.layer.borderWidth = 1.f;
    
    self.uploadBtn.layer.cornerRadius = 5.f;
    self.uploadBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.uploadBtn.layer.borderWidth = 1.f;
    
    self.noticeLabel.text = @"1、请勿使用手机浏览器打开地址；\n2、地址仅可访问一次，请确保正确操作；\n3、如误操作导致PC页面关闭，请关闭本页面重新进入获取地址；\n4、上传后无反应请联系客服。";
    
}

//重点在viewWillAppear方法里调用下面两个方法
-(void)viewWillAppear:(BOOL)animated{
    [self preferredStatusBarStyle];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self postRequest];
}

/**
 请求数据
 */
- (void)postRequest {

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    dict[@"item_id"] = self.item_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kUpload_URL paramDic:dict finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE) {
            
            self.linkLabel.text = responseObject[@"data"][@"url"];
            
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            [MBProgressHUD showError:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
        
        [_loadV removeloadview];
        
    }];
}

/**
 返回
 */
- (IBAction)close:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 复制链接
 */
- (IBAction)copyLink:(id)sender {
    
    if (self.linkLabel.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"链接未请求成功!"];
        return;
    }
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.linkLabel.text;
    
    [SVProgressHUD showSuccessWithStatus:@"复制链接成功!"];
}

/**
 已上传文件
 */
- (IBAction)uploadedFile:(id )sender {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定已经上传了文件" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GLMineController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }

    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:ok];

    [self presentViewController:alertVC animated:YES completion:nil];

}


@end
