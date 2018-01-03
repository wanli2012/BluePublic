//
//  GLPublish_UploadController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/12/29.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_UploadController.h"
#import "GLPublish_WebsiteController.h"

@interface GLPublish_UploadController ()
{
    BOOL _isAgreeProtocol;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *noInsureImageV;
@property (weak, nonatomic) IBOutlet UIImageView *selfInsureImageV;
@property (weak, nonatomic) IBOutlet UIImageView *projectInsreImageV;
@property (weak, nonatomic) IBOutlet UIImageView *isAgreeImageV;

@end

@implementation GLPublish_UploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.submitBtn.layer.cornerRadius = 5.f;
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 600;
    _isAgreeProtocol = NO;
    
}

#pragma mark - 跳转到协议
- (IBAction)toProtocol:(id)sender {
}
#pragma mark - 是否同意协议
- (IBAction)isAgreeProtocol:(id)sender {
    _isAgreeProtocol = !_isAgreeProtocol;
    
    if (_isAgreeProtocol) {
        
        self.isAgreeImageV.image = [UIImage imageNamed:@"publish_choice"];
    }else{
        self.isAgreeImageV.image = [UIImage imageNamed:@"publish_nochoice"];
    }
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    
}

#pragma mark - 投保方式选择
- (IBAction)insureChoose:(UITapGestureRecognizer *)tap {
    
    self.noInsureImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    self.selfInsureImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    self.projectInsreImageV.image = [UIImage imageNamed:@"nochoice_grey"];
    
    switch (tap.view.tag) {
        case 11:
        {
            self.noInsureImageV.image = [UIImage imageNamed:@"mine_choice"];
            
        }
            break;
        case 12:
        {
            self.selfInsureImageV.image = [UIImage imageNamed:@"mine_choice"];
        }
            break;
        case 13:
        {
            self.projectInsreImageV.image = [UIImage imageNamed:@"mine_choice"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 上传项目承诺书
- (IBAction)uploadProjectCommitment:(id)sender {
    
    GLPublish_WebsiteController *websiteVC= [[GLPublish_WebsiteController alloc] init];
    [self presentViewController:websiteVC  animated:YES completion:nil];
    
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"dd" message:@"haha" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"打的费");
//    }];
//
//    [alertVC addAction:ok];
//    [alertVC addAction:cancel];
//    [self presentViewController:alertVC animated:YES completion:nil];
    
}
#pragma mark - 上传项目回馈计划书

/**
 上传项目回馈计划书
 @param sender 没有使用
 
 */
- (IBAction)uploadProjectFeedback:(id)sender {
}
#pragma mark - 上传项目计划书
- (IBAction)uploadProjectPlan:(id)sender {
}
#pragma mark - 上传项目资金使用计划书
- (IBAction)uploadProjectFundUsing:(id)sender {
}

@end

