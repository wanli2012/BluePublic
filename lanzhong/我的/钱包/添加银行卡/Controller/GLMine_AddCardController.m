//
//  GLMine_AddCardController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_AddCardController.h"


@interface GLMine_AddCardController ()
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end

@implementation GLMine_AddCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"添加银行卡";
    self.ensureBtn.layer.cornerRadius = 5.f;

}

- (IBAction)bankCardChoose:(id)sender {
    NSLog(@"选择银行");
    
}
- (IBAction)ensure:(id)sender {
    NSLog(@"确定");
}

@end
