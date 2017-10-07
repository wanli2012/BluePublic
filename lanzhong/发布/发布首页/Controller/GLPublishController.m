//
//  GLPublishController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLPublishController.h"


@interface GLPublishController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation GLPublishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.shadowOpacity = 0.1f;
    self.bgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.bgView.layer.shadowRadius = 1.f;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)dismiss:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



@end
