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

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation GLPublish_UploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = 600;
    _isAgreeProtocol = NO;
    
    self.navigationItem.title = @"上传文件";
    
    self.noticeLabel.text = @"1、项目提交成功后由此页面提交相关文件；2、上传文件包括《个人承诺书》、《项目计划书》、《项目回馈计划书》、《项目资金使用计划书》；3、必须保证所有文件的真实性；4、文件最终解释权归发布者所有；";    
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;//白色
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
    
    [self setStatusBarBackgroundColor:[UIColor clearColor]];
    
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - 上传文件
/**
 上传文件

 */
- (IBAction)uploadFile:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLPublish_WebsiteController *websiteVC= [[GLPublish_WebsiteController alloc] init];
    websiteVC.item_id = self.item_id;
    [self.navigationController pushViewController:websiteVC animated:YES];
    
}


@end
