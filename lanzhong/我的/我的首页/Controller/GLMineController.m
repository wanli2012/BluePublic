//
//  GLMineController.m
//  lanzhong
//
//  Created by 龚磊 on 2017/9/25.
//  Copyright © 2017年 三君科技有限公司. All rights reserved.
//

#import "GLMineController.h"
#import "GLMineCell.h"
#import "GLMine_SetController.h"//设置
#import "GLMine_PersonInfoController.h"//个人信息
#import "GLMine_MyProjectController.h"//我的项目
#import "GLShoppingCartController.h"//购物车
#import "GLMine_MyMessageController.h"//我的消息
#import "GLMine_WalletController.h"//钱包
#import "GLMine_MyOrderController.h"//我的订单
#import "GLMine_ParticipateController.h"//我参与的项目
#import "GLMine_EvaluateController.h"//我的评价
#import "GLMine_ShareController.h"//分享权益
#import "GLPublishController.h"//发布项目
#import "GLMine_CurriculumVitaeController.h"//我的简历
#import "GLMine_TrainController.h"//我的培训
#import "GLMine_IntegralController.h"//我的积分
#import "GLMine_MyBillController.h"//我的账单

#import "BaseNavigationViewController.h"
#import "GLLoginController.h"

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *bgView;//topView
@property (weak, nonatomic) IBOutlet UIImageView *bgimageV;//背景图
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//头像
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//用户昵称
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//实名认证状态
@property (weak, nonatomic) IBOutlet UIView *middleView;//中间6个label的背景View
@property (weak, nonatomic) IBOutlet UILabel *participateLabel;//参与项目个数
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;//发布项目个数
@property (weak, nonatomic) IBOutlet UILabel *banlanceLabel;//余额

@property (nonatomic, strong)NSMutableArray *dataSource;//显示数据_数据源
@property (nonatomic, strong)LoadWaitView *loadV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImageVTopConstrait;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstrait;


@property(nonatomic,strong)UIImageView *backgroundImgV;
@property(nonatomic,assign)float backImgHeight;
@property(nonatomic,assign)float backImgWidth;

@end

#define kHEIGHT 170

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view insertSubview:self.backgroundImgV belowSubview:self.tableView];
    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    if(kSCREEN_HEIGHT == 812){
        self.bgImageVTopConstrait.constant = -44;
    }else{
        self.bgImageVTopConstrait.constant = 0;
    }
    
}

- (UIImageView *)backgroundImgV{
    if (!_backgroundImgV) {
        _backgroundImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 170)];
        _backgroundImgV.contentMode = UIViewContentModeScaleAspectFill;
        UIImage *image=[UIImage imageNamed:@"blackground"];
        _backgroundImgV.image=image;
        _backgroundImgV.userInteractionEnabled=YES;
        _backImgHeight=_backgroundImgV.frame.size.height;
        _backImgWidth=_backgroundImgV.frame.size.width;
    }
    return _backgroundImgV;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self postRequest];
}

#pragma mark - 设置界面
- (void)setUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.height = 235;
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    self.imageV.image = [UIImage imageNamed:PicHolderImage];
    
    self.middleView.layer.cornerRadius = 5.f;

}

#pragma mark - 个人信息
- (IBAction)personInfo:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfoController *personVC = [[GLMine_PersonInfoController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 请求数据
-(void)postRequest {
    
    if ([UserModel defaultUser].token.length == 0) {
        return;
    }
    if ([UserModel defaultUser].uid.length == 0) {
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [UserModel defaultUser].address = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"address"]];
            [UserModel defaultUser].area = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"area"]];
            [UserModel defaultUser].city = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"city"]];
            [UserModel defaultUser].del = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"del"]];
            [UserModel defaultUser].g_id = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"g_id"]];
            [UserModel defaultUser].g_name = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"g_name"]];
            [UserModel defaultUser].idcard = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"idcard"]];
            [UserModel defaultUser].invest_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"invest_count"]];
            [UserModel defaultUser].is_help = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"is_help"]];
            [UserModel defaultUser].item_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"item_count"]];
            [UserModel defaultUser].nickname = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"nickname"]];
            [UserModel defaultUser].phone = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"phone"]];
            [UserModel defaultUser].province = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"province"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"real_state"]];
            [UserModel defaultUser].real_time = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"real_time"]];
            [UserModel defaultUser].token = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"token"]];
            [UserModel defaultUser].truename = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"truename"]];
            [UserModel defaultUser].uid = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"uid"]];
            [UserModel defaultUser].umark = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umark"]];
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].uname = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"uname"]];
            [UserModel defaultUser].user_pic = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_pic"]];
            [UserModel defaultUser].user_server = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"user_server"]];
            [UserModel defaultUser].item_money = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"item_money"]];
            
            [self judgeNull];//判空
            
            [usermodelachivar achive];
            [self assignment];//为头视图赋值
            
        }else if([responseObject[@"code"] integerValue] == OVERDUE_CODE){
            
            if ([UserModel defaultUser].loginstatus) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
            GLLoginController *loginVC = [[GLLoginController alloc] init];
            loginVC.sign = 1;
            BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:loginVC];
            nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:nav animated:YES completion:nil];
            
        }else{
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } enError:^(NSError *error) {
    }];
}
//判空
- (void)judgeNull {
    if ([[UserModel defaultUser].item_money rangeOfString:@"null"].location != NSNotFound) {
        [UserModel defaultUser].item_money = @"0";
    }
}

#pragma mark - 头视图赋值
- (void)assignment{
    
    self.participateLabel.text = [UserModel defaultUser].item_count;
    self.publishLabel.text = [UserModel defaultUser].invest_count;
    self.banlanceLabel.text = [UserModel defaultUser].item_money;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[UserModel defaultUser].user_pic] placeholderImage:[UIImage imageNamed:PicHolderImage]];
    
    if ([UserModel defaultUser].nickname.length == 0) {
        self.nicknameLabel.text = @"蓝众创客";
    }else{
        self.nicknameLabel.text = [UserModel defaultUser].nickname;
    }
    
    NSString *str;
    switch ([[UserModel defaultUser].real_state integerValue]) {
        case 0:
        {
            str = @"未认证";
        }
            break;
        case 1:
        {
            str = @"已认证";
        }
            break;
        case 2:
        {
            str = @"认证失败";
        }
            break;
        case 3:
        {
            str = @"审核中";
        }
            break;
        default:
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"实名认证:%@",str];
}

#pragma mark - 我的审核 我的项目 我的筹款
- (IBAction)myExamine:(id)sender {
    GLMine_MyProjectController *myExamineVC = [[GLMine_MyProjectController alloc] initWithSignIndex:1];
    [self.navigationController pushViewController:myExamineVC animated:YES];
}

- (IBAction)myProject:(id)sender {
    GLMine_MyProjectController *myProjectVC = [[GLMine_MyProjectController alloc] initWithSignIndex:2];
    [self.navigationController pushViewController:myProjectVC animated:YES];
}

- (IBAction)myFundraising:(id)sender {
    GLMine_MyProjectController *myFundraisingVC = [[GLMine_MyProjectController alloc] initWithSignIndex:0];
    [self.navigationController pushViewController:myFundraisingVC animated:YES];
}

#pragma mark - 设置
- (IBAction)set:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_SetController *setVC = [[GLMine_SetController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}

#pragma mark - 消息
- (IBAction)message:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_MyMessageController *setVC = [[GLMine_MyMessageController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
#pragma mark - UIScrollViewDelegate 下拉放大图片
//scrollView的方法视图滑动时 实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    CGFloat width = self.view.frame.size.width;
    // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset<0) {
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight-yOffset;
        rect.size.width = _backImgWidth* (_backImgHeight-yOffset)/_backImgHeight;
        rect.origin.x =  -(rect.size.width-_backImgWidth)/2;
        rect.origin.y = 0;
        _backgroundImgV.frame = rect;
    }else{
        CGRect rect = _backgroundImgV.frame;
        rect.size.height = _backImgHeight;
        rect.size.width = _backImgWidth;
        rect.origin.x = 0;
        rect.origin.y = -yOffset;
        _backgroundImgV.frame = rect;
        
    }
    // 偏移的y值
//    if(yOffset < 0){
    
//        CGFloat totalOffset = kHEIGHT + ABS(yOffset);
//        CGFloat f = totalOffset / kHEIGHT;
//        //拉伸后的图片的frame应该是同比例缩放。
//        if (@available(iOS 11.0, *)) {
//            BOOL first = YES;
//            if(first){
//                self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
//                self.bgImageVTopConstrait.constant = -20;
//                first = NO;
//            }
//        }
//
//        self.bgimageV.frame =  CGRectMake(- (width *f-width) / 2, yOffset, width * f, totalOffset);
//    }

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GLMineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMineCell"];
    cell.selectionStyle = 0;
    
    NSArray *arr = self.dataSource[indexPath.section];
    cell.titleLabel.text = arr[indexPath.row][@"title"];
    cell.picImageV.image = [UIImage imageNamed:arr[indexPath.row][@"image"]];
    cell.status = 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0://发布项目
                {
                    if ([[UserModel defaultUser].real_state integerValue] == 0 || [[UserModel defaultUser].real_state integerValue] == 2) {
                        [SVProgressHUD showErrorWithStatus:@"请前往个人中心实名认证"];
                        return;
                    }else if([[UserModel defaultUser].real_state integerValue] == 3){
                        [SVProgressHUD showErrorWithStatus:@"实名认证审核中,请等待"];
                        return;
                    }

                    GLPublishController *publishVC = [[GLPublishController alloc] init];
                    [self.navigationController pushViewController:publishVC animated:YES];
                }
                    break;
                case 1://我帮助过
                {
                    GLMine_ParticipateController *participateVC = [[GLMine_ParticipateController alloc] init];
                    [self.navigationController pushViewController:participateVC animated:YES];
                }
                    break;
                case 2://我的简历
                {
                    GLMine_CurriculumVitaeController *cv = [[GLMine_CurriculumVitaeController alloc] init];
                    [self.navigationController pushViewController:cv animated:YES];
                }
                    break;
                    
                case 3://我的培训
                {
                    GLMine_TrainController *trainVC = [[GLMine_TrainController alloc] init];
                    [self.navigationController pushViewController:trainVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {

                case 0://我的钱包
                {
                    GLMine_WalletController *walletVC = [[GLMine_WalletController alloc] init];
                    [self.navigationController pushViewController:walletVC animated:YES];
                }
                    break;
                case 1://我的积分
                {
                    GLMine_IntegralController *integralVC = [[GLMine_IntegralController alloc] init];
                    [self.navigationController pushViewController:integralVC animated:YES];
                    
                }
                    break;
                case 2://我的账单
                {
                    GLMine_MyBillController *billVC = [[GLMine_MyBillController alloc] init];
                    [self.navigationController pushViewController:billVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0://购物车
                {
                    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
                    [self.navigationController pushViewController:cartVC animated:YES];
                }
                    break;
                case 1://我的评价
                {
                    GLMine_EvaluateController *evaluateVC = [[GLMine_EvaluateController alloc] init];
                    [self.navigationController pushViewController:evaluateVC animated:YES];
                }
                    break;
                case 2://我的订单
                {
                    GLMine_MyOrderController *cartVC = [[GLMine_MyOrderController alloc] init];
                    [self.navigationController pushViewController:cartVC animated:YES];
                }
                    break;
              
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            GLMine_ShareController *shareVC = [[GLMine_ShareController alloc] init];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
            
        default:
            break;
            
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 5)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 3;
}

#pragma mark - 懒加载
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        
        NSArray *arr1 = @[@{@"title":@"项目发布",@"image":@"我要发布"},
                          @{@"title":@"我帮助过",@"image":@"我帮助过"},
                          @{@"title":@"我的简历",@"image":@"我的简历"},
                          @{@"title":@"我的培训",@"image":@"我的培训"}
                          ];
        
        NSArray *arr2 = @[@{@"title":@"我的钱包",@"image":@"我的钱包"},
                          @{@"title":@"我的积分",@"image":@"我的积分"},
                          @{@"title":@"我的账单",@"image":@"我的账单"}
                          ];
    
        NSArray *arr3 = @[@{@"title":@"购物车",@"image":@"购物车"},
                          @{@"title":@"商品评价",@"image":@"我的评价"},
                          @{@"title":@"我的订单",@"image":@"我的订单"}
                          ];
        
        NSArray *arr4 = @[@{@"title":@"分享权益",@"image":@"分享权益"}];
        
        [_dataSource addObject:arr1];
        [_dataSource addObject:arr2];
        [_dataSource addObject:arr3];
        [_dataSource addObject:arr4];
    }
    return _dataSource;
}

@end
