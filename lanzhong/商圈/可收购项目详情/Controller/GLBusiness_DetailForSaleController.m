//
//  GLBusiness_DetailForSaleController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/6.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLBusiness_DetailForSaleController.h"
#import "GLBusiness_DetailForSaleModel.h"
#import "GLBusiness_CertificationController.h"

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
    
    self.contentViewHeight.constant = 847;
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
    dic[@"attorn_id"] = self.attorn_id;
    
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
#pragma mark - 页面赋值
/**
 为页面赋值
 */
- (void)headerViewFuzhi {
    
    ///赋值
    [self.projectImageV sd_setImageWithURL:[NSURL URLWithString:self.model.sev_photo] placeholderImage:[UIImage imageNamed:PlaceHolderImage]];
    self.projectNameLabel.text = self.model.title;
    self.projectHeadLabel.text = self.model.nickname;
    self.sumMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.admin_money];
    self.briefLabel.text = self.model.info;
    self.futureMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.attorn_money];
    self.investorLabel.text = self.model.nickname;
    
    CGFloat radio;
    if ([self.model.admin_money floatValue] == 0) {
        radio = 0;
    }else{
        
        radio = [self.model.money floatValue] / [self.model.admin_money floatValue];
        
    }
    
    self.investRatioLabel.text = [NSString stringWithFormat:@"%.2f%%",radio * 100];
    self.investMoneyLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.money];;
    self.investProfitLabel.text = [NSString stringWithFormat:@"¥ %@",self.model.item_get_money];
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
    
    CGRect rect = [self.model.info boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    
    self.contentViewHeight.constant = 857 + rect.size.height;
    self.contentViewWidth.constant = kSCREEN_WIDTH;
    
}

#pragma mark - 关于保障
/**
 保障内容
 */
- (IBAction)ensureContent:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *webVC = [[GLBusiness_CertificationController alloc] init];

    if ([self.model.ensure_type integerValue] == 1) {//1无保障计划  2项目发布人自保  3项目出保
        [SVProgressHUD showErrorWithStatus:@"无保障计划"];
        return;
        
    }else if([self.model.ensure_type integerValue] == 2){
        webVC.url = [NSString stringWithFormat:@"%@%@",URL_Base,kInenure_Person_URL];
        webVC.navTitle = @"个人保障规则";
        
    }else if([self.model.ensure_type integerValue] == 3){
        webVC.url = [NSString stringWithFormat:@"%@%@",URL_Base,kInenure_Project_URL];
        webVC.navTitle = @"筹款保障规则";
    }
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - 有关文件
/**
 项目回馈计划

 */
- (IBAction)feedBack:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *webVC = [[GLBusiness_CertificationController alloc] init];
    webVC.url = self.model.rights_word;
    webVC.navTitle = @"项目回馈计划书";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 项目资金使用计划书

 */
- (IBAction)projectBund:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *webVC = [[GLBusiness_CertificationController alloc] init];
    webVC.url = self.model.money_use_word;
    webVC.navTitle = @"项目资金使用计划书";
    [self.navigationController pushViewController:webVC animated:YES];
}

/**
 承诺书

 */
- (IBAction)commitLetter:(id)sender {
   self.hidesBottomBarWhenPushed = YES;
    GLBusiness_CertificationController *webVC = [[GLBusiness_CertificationController alloc] init];
    webVC.url = self.model.promise_word;
    webVC.navTitle = @"个人承诺书";
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}

#pragma mark - 打电话 立即收购
/**
 打电话
 */
- (IBAction)call:(id)sender {
    
    NSString *phone = [NSString stringWithFormat:@"tel://%@",self.model.attorn_phone];
    NSURL *url = [NSURL URLWithString:phone];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
        
    }];
  
}

/**
 立即收购

 */
- (IBAction)buyNow:(id)sender {
    NSLog(@"立即收购");
}

@end
