//
//  GLMine_PersonInfoController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/28.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_PersonInfoController.h"

@interface GLMine_PersonInfoController ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation GLMine_PersonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"个人信息";
    
    self.picImageV.layer.cornerRadius = self.picImageV.height/2;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT - 64;
    self.ensureBtn.layer.cornerRadius = 5.f;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)ensure:(id)sender {
    NSLog(@"确定");
}
- (IBAction)address:(id)sender {
    
    
}


@end
