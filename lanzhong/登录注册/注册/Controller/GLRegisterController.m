//
//  GLRegisterController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/6.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLRegisterController.h"

@interface GLRegisterController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@end

@implementation GLRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentWidth.constant = kSCREEN_WIDTH;
    self.contentHeight.constant = kSCREEN_HEIGHT - 64;
    
    self.getCodeBtn.layer.borderWidth = 1.f;
    self.getCodeBtn.layer.borderColor = YYSRGBColor(0, 126, 255, 1).CGColor;
    self.getCodeBtn.layer.cornerRadius = 5.f;
    
    
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    self.imageV.layer.borderColor = [UIColor blueColor].CGColor;
    self.imageV.layer.borderWidth = 1.f;
    
    
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.shadowOpacity = 0.2f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowRadius = 3.f;
    self.bgView.layer.shadowColor = [UIColor blueColor].CGColor;
    
    self.registerBtn.layer.cornerRadius = 5.f;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (IBAction)privacy:(id)sender {
    NSLog(@"隐私权益");
}
- (IBAction)login:(id)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
