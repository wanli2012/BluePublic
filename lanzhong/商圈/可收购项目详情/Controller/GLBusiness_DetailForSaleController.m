//
//  GLBusiness_DetailForSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/6.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailForSaleController.h"

@interface GLBusiness_DetailForSaleController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;//contentView高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidth;//contentView宽度


@property (weak, nonatomic) IBOutlet UIImageView *projectImageV;//项目图片
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名称
@property (weak, nonatomic) IBOutlet UILabel *projectHeadLabel;//项目负责人
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;//集资金额
@property (weak, nonatomic) IBOutlet UILabel *insureLabel;//项目参保方式
@property (weak, nonatomic) IBOutlet UILabel *briefLabel;//项目简介
@property (weak, nonatomic) IBOutlet UILabel *futureMoneyLabel;//预估价格
@property (weak, nonatomic) IBOutlet UILabel *investorLabel;//投资人
@property (weak, nonatomic) IBOutlet UILabel *investMoneyLabel;//投资金额
@property (weak, nonatomic) IBOutlet UILabel *investRatioLabel;//投资占比
@property (weak, nonatomic) IBOutlet UILabel *investProfitLabel;//投资盈利
@property (weak, nonatomic) IBOutlet UILabel *bonusDateLabel;//分红日期
@property (weak, nonatomic) IBOutlet UILabel *lastBonusDateLabel;//最近分红日期
@property (weak, nonatomic) IBOutlet UILabel *lastBonusProfitLabel;//最近分红金额

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//联系电话
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;//立即收购

@end

@implementation GLBusiness_DetailForSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"你的骄傲了商店家傅雷家书雷锋精神龙卷风;连手机分类静安寺六块腹肌按理说就法拉盛就发;辣椒水;冷风机爱上了放假啊设计费;拉健身房索拉卡就法拉盛就附近啊放假是发死垃圾费;拉设计费离开家暗示法律看见爱上了积分;就爱上对方就爱上了就发健身房了控件是否理解是垃圾分类静安寺六块腹肌;拉卡萨解放路;家拉设计费;廉价啊是否;廉价啊是零点会计法;垃圾水电费;垃圾爱上;了返回键阿斯蒂芬";
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];

    self.contentViewHeight.constant = 1047 + rect.size.height;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
    self.buyNowBtn.layer.cornerRadius = 5.f;
    
    self.navigationItem.title = @"项目详情";
    
    
    ///赋值
    self.projectImageV.backgroundColor = [UIColor lightGrayColor];
    self.projectNameLabel.text = @"流浪狗之家";
    self.projectHeadLabel.text = @"流浪";
    self.sumMoneyLabel.text = @"¥ 3333";
    self.insureLabel.text = @"自行投保";
    self.briefLabel.text = str;
    self.futureMoneyLabel.text = @"¥ 333";
    self.investorLabel.text = @"磊哥";
    self.investRatioLabel.text = @"10%";
    self.investMoneyLabel.text = @"";
    self.investProfitLabel.text = @"¥ 33";
    self.bonusDateLabel.text = @"每月28号";
    self.lastBonusDateLabel.text = @"2018-01-01";
    self.lastBonusProfitLabel.text = @"¥ 3";
    self.phoneLabel.text = @"18513366125";
    
    
}

#pragma mark - 关于保障
/**
 理赔流程
 
 */
- (IBAction)claimProcess:(id)sender {
    NSLog(@"理赔流程");
}

/**
 保障内容
 
 */
- (IBAction)ensureContent:(id)sender {
    NSLog(@"保障内容");
}

#pragma mark - 有关文件
/**
 项目回馈计划

 */
- (IBAction)feedBack:(id)sender {
    NSLog(@"项目回馈计划");
}

/**
 项目资金使用计划书

 */
- (IBAction)projectBund:(id)sender {
    NSLog(@"项目资金使用计划书");
}

/**
 承诺书

 */
- (IBAction)commitLetter:(id)sender {
    NSLog(@"承诺书");
}

/**
 项目计划书
 
 */
- (IBAction)projectPlan:(id)sender {
    NSLog(@"项目计划书");
}

#pragma mark - 打电话 立即收购
/**
 打电话
 */
- (IBAction)call:(id)sender {
    NSLog(@"打电话");
}

/**
 立即收购

 */
- (IBAction)buyNow:(id)sender {
    NSLog(@"立即收购");
}

@end
