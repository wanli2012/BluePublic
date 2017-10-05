//
//  GLMine_WalletController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/10/5.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMine_WalletController.h"
#import "GLMine_WalletDetailController.h"//明细
#import "GLMine_AddCardController.h"//添加银行卡
#import "GLMine_WalletCardChooseController.h"//选择银行卡

@interface GLMine_WalletController ()

@property (weak, nonatomic) IBOutlet UIView *topBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIView *rechargeView;
@property (weak, nonatomic) IBOutlet UIButton *ensurePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *ensureExchangeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *addImageV;
@property (weak, nonatomic) IBOutlet UILabel *addCardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bankIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;


@end

@implementation GLMine_WalletController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"钱包";
    
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    self.contentViewHeight.constant = kSCREEN_HEIGHT;
    self.topBgView.layer.cornerRadius = 5.f;
    
    self.topBgView.layer.shadowOpacity = 0.2f;
    self.topBgView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.topBgView.layer.shadowRadius = 2.f;
    
    self.ensurePayBtn.layer.cornerRadius = 5.f;
    self.ensureExchangeBtn.layer.cornerRadius = 5.f;
    
    self.addImageV.hidden = NO;
    self.addCardLabel.hidden = NO;
    
    self.bankIconImageV.hidden = YES;
    self.bankNameLabel.hidden = YES;
    self.bankNumLabel.hidden = YES;
    self.arrowImageV.hidden = YES;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    [btn setTitle:@"明细" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//(需要何值请参看API文档)
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0 ,0, 0, 10)];
    // 让返回按钮内容继续向左边偏移10
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -17);
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(detail) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
//明细
- (void)detail{
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_WalletDetailController *detailVC = [[GLMine_WalletDetailController alloc] init];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (IBAction)switchFunc:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        
        self.rechargeView.hidden = YES;
    
    }else if (sender.selectedSegmentIndex == 1){
        
        self.rechargeView.hidden = NO;
    }
    
}
//添加银行卡
- (IBAction)addCard:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLMine_AddCardController *addVC = [[GLMine_AddCardController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
    
}
- (IBAction)chooseCard:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_WalletCardChooseController *cardChooseVC = [[GLMine_WalletCardChooseController alloc] init];
    [self.navigationController pushViewController:cardChooseVC animated:YES];
}

@end
