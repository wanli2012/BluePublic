//
//  GLPublish_WebsiteController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/2.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLPublish_WebsiteController.h"

@interface GLPublish_WebsiteController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

@property (weak, nonatomic) IBOutlet UILabel *linkLabel;//链接Label
@property (weak, nonatomic) IBOutlet UIButton *linkCopyBtn;//复制链接
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;//已上传
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;//注意事项

@end

@implementation GLPublish_WebsiteController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentHeight.constant = 650;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
    self.linkCopyBtn.layer.cornerRadius = 5.f;
    self.linkCopyBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.linkCopyBtn.layer.borderWidth = 1.f;
    
    self.uploadBtn.layer.cornerRadius = 5.f;
    self.uploadBtn.layer.borderColor = MAIN_COLOR.CGColor;
    self.uploadBtn.layer.borderWidth = 1.f;
    
    self.noticeLabel.text = @"1、上传文件包括承诺书、项目回馈计划书、项目计划书、项目资金使用计划书；\n2、文件上传后不可更改，请保证文件的真实性；\n3、上传成功但无反应请联系客服；";
    
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;//白色
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

//！！！重点在viewWillAppear方法里调用下面两个方法
-(void)viewWillAppear:(BOOL)animated{
    [self preferredStatusBarStyle];
//    [self setStatusBarBackgroundColor:MAIN_COLOR];
    self.navigationController.navigationBar.hidden = NO;
}

/**
 复制链接
 
 */
- (IBAction)copyLink:(id)sender {
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.linkLabel.text;
    
    [SVProgressHUD showSuccessWithStatus:@"复制链接成功!"];
}

/**
 已上传文件

 */
- (IBAction)uploadedFile:(id)sender {
    NSLog(@"我已上传文件");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadFileNotification" object:nil];;
}


@end
