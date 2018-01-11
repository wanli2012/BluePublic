//
//  GLBusiness_DetailForSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/6.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailForSaleController.h"
#import "GLBusiness_DetailForSaleModel.h"

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

@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, strong)GLBusiness_DetailForSaleModel *model;
@property (nonatomic, assign)BOOL  HideNavagation;//是否需要恢复自定义导航栏

@end

@implementation GLBusiness_DetailForSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.buyNowBtn.layer.cornerRadius = 5.f;
    self.navigationItem.title = @"项目详情";
    
    self.contentViewHeight.constant = 947;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
    [self postRequest:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"supportNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}
/**
 接到通知刷新数据
 */
-(void)refresh{
    
    [self postRequest:YES];
}

#pragma mark - 请求数据
/**
 请求数据
 @param isRefresh 是否是下拉刷新
 */
- (void)postRequest:(BOOL)isRefresh{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"attorn_id"] = self.item_id;
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kAttorm_Item_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
                self.model = [GLBusiness_DetailForSaleModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self headerViewFuzhi];
            }
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }

    } enError:^(NSError *error) {
        [_loadV removeloadview];
        
    }];
}

/**
 为头视图赋值
 */
- (void)headerViewFuzhi {
    
    ///赋值
    self.projectImageV.backgroundColor = [UIColor lightGrayColor];
    self.projectNameLabel.text = self.model.title;
    self.projectHeadLabel.text = self.model.nickname;
    self.sumMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.admin_money];
    self.briefLabel.text = self.model.info;
    self.futureMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.attorn_money];
    self.investorLabel.text = self.model.nickname;
    self.investRatioLabel.text = @"10%";
    self.investMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.money];;
    self.investProfitLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.item_get_money];
    self.bonusDateLabel.text = @"每月28号";
    self.lastBonusDateLabel.text = [formattime formateTime:self.model.item_get_time];
    self.lastBonusProfitLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.item_get_money_sum];
    self.phoneLabel.text = self.model.attorn_phone;
    
    switch ([self.model.ensure_type integerValue]) {
        case 1:
        {
            self.insureLabel.text = @"无保障计划";
        }
            break;
        case 2:
        {
            self.insureLabel.text = @"个人保障";
        }
            break;
        case 3:
        {
            self.insureLabel.text = @"官方保障";
        }
            break;
            
        default:
            break;
    }
    
//    NSString *str = @"你的骄傲了商店家傅雷家书雷锋精神龙卷风;连手机分类静安寺六块腹肌按理说就法拉盛就发;辣椒水;冷风机爱上了放假啊设计费;拉健身房索拉卡就法拉盛就附近啊放假是发死垃圾费;拉设计费离开家暗示法律看见爱上了积分;就爱上对方就爱上了就发健身房了控件是否理解是垃圾分类静安寺六块腹肌;拉卡萨解放路;家拉设计费;廉价啊是否;廉价啊是零点会计法;垃圾水电费;垃圾爱上;了返回键阿斯蒂芬";
    
    CGRect rect = [self.model.info boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    
    self.contentViewHeight.constant = 947 + rect.size.height;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
}

#pragma mark - 关于保障
/**
 理赔流程
 
 */
//- (IBAction)claimProcess:(id)sender {
//    NSLog(@"理赔流程");
//}

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
