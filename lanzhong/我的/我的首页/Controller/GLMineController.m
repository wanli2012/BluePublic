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

#import "GLMine_AddFundTrendController.h"//添加资金动向

@interface GLMineController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;//透视图
@property (weak, nonatomic) IBOutlet UIView *bgView;//topView
@property (weak, nonatomic) IBOutlet UIImageView *bgimageV;//背景图
@property (weak, nonatomic) IBOutlet UIImageView *imageV;//头像
@property (weak, nonatomic) IBOutlet UIView *middleView;//中间6个label的背景View

@property (weak, nonatomic) IBOutlet UILabel *participateLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishLabel;
@property (weak, nonatomic) IBOutlet UILabel *banlanceLabel;


@property (nonatomic, strong)UIVisualEffectView *visualEffectView;

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, strong)LoadWaitView *loadV;

@end

#define kHEIGHT 150

@implementation GLMineController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMineCell" bundle:nil] forCellReuseIdentifier:@"GLMineCell"];
    
}

- (void)setUI {
    
    self.view.backgroundColor = [UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.imageV.layer.cornerRadius = self.imageV.height/2;
    
    //实现模糊效果
    UIBlurEffect *blurEffrct = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    
    self.visualEffectView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.bgimageV.height);
    
    self.visualEffectView.alpha = 0.95;
    
    [self.bgimageV addSubview:self.visualEffectView];
    
    self.middleView.layer.cornerRadius = 5.f;

}

//个人信息
- (IBAction)personInfo:(id)sender {
    
    self.hidesBottomBarWhenPushed = YES;
    GLMine_PersonInfoController *personVC = [[GLMine_PersonInfoController alloc] init];
    [self.navigationController pushViewController:personVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self postRequest];
}

//请求数据
-(void)postRequest {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"token"] = [UserModel defaultUser].token;
    dict[@"uid"] = [UserModel defaultUser].uid;
    
//    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kREFRESH_URL paramDic:dict finish:^(id responseObject) {
        
//        [_loadV removeloadview];

        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            
            [UserModel defaultUser].umoney = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"umoney"]];
            [UserModel defaultUser].invest_count = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"invest_count"]];
            [UserModel defaultUser].item_count = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"item_count"]];
            [UserModel defaultUser].user_server = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"user_server"]];
            [UserModel defaultUser].real_state = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"real_state"]];
            
            [usermodelachivar achive];
  
            self.participateLabel.text = [UserModel defaultUser].invest_count;
            self.publishLabel.text = [UserModel defaultUser].item_count;
            self.banlanceLabel.text = [UserModel defaultUser].umoney;
            
        }
        
    } enError:^(NSError *error) {
//        [_loadV removeloadview];
    }];
}

#pragma mark - UIScrollViewDelegate 下拉放大图片
//scrollView的方法视图滑动时 实时调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.view.frame.size.width;
    // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;
    // 偏移的y值
    
    if(yOffset < 0){
        
        CGFloat totalOffset = kHEIGHT + ABS(yOffset);
        CGFloat f = totalOffset / kHEIGHT;
        //拉伸后的图片的frame应该是同比例缩放。
        self.bgimageV.frame =  CGRectMake(- (width *f-width) / 2, yOffset, width * f, totalOffset);
        self.visualEffectView.frame = CGRectMake(0, 0, width * f, totalOffset);
        
    }
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
            GLMine_MyProjectController *myProjectVC = [[GLMine_MyProjectController alloc] initWithSignIndex:indexPath.row];

            [self.navigationController pushViewController:myProjectVC animated:YES];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    GLMine_ParticipateController *participateVC = [[GLMine_ParticipateController alloc] init];
                    [self.navigationController pushViewController:participateVC animated:YES];
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
                case 0:
                {
                    GLShoppingCartController *cartVC = [[GLShoppingCartController alloc] init];
                    [self.navigationController pushViewController:cartVC animated:YES];
                    
                }
                    break;
                case 1://
                {
                    NSLog(@"我的订单");
                    GLMine_MyOrderController *cartVC = [[GLMine_MyOrderController alloc] init];
                    [self.navigationController pushViewController:cartVC animated:YES];
                    
                }
                    break;
                case 2:
                {
                    
                    GLMine_WalletController *walletVC = [[GLMine_WalletController alloc] init];
                    [self.navigationController pushViewController:walletVC animated:YES];

                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 3:{
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"分享权益");
                    GLMine_AddFundTrendController *addFundVC = [[GLMine_AddFundTrendController alloc] init];
                    [self.navigationController pushViewController:addFundVC animated:YES];
                    
                }
                    break;
                case 1://我的消息
                {
                    
                    GLMine_MyMessageController *myMessageVC = [[GLMine_MyMessageController alloc] init];
                    [self.navigationController pushViewController:myMessageVC animated:YES];
                    
                }
                    break;
                case 2:
                {
                    
                    GLMine_SetController *setVC = [[GLMine_SetController alloc] init];
                    [self.navigationController pushViewController:setVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            
        default:
            break;
    }
    self.hidesBottomBarWhenPushed = NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
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
        
        NSArray *arr = @[@{@"title":@"我的审核",@"image":@"zhang"},
                         @{@"title":@"我的筹款",@"image":@"money"},
                         @{@"title":@"我的项目",@"image":@"myproject"}];
        
        NSArray *arr2 = @[@{@"title":@"参与项目",@"image":@"participationproject"}];
        
        NSArray *arr3 = @[@{@"title":@"购物车",@"image":@"mine_shoppingcart"},
                          @{@"title":@"订单",@"image":@"order"},
                          @{@"title":@"钱包",@"image":@"wallet"},
                          ];
        NSArray *arr4 = @[@{@"title":@"分享权益",@"image":@"mine_share"},
                          @{@"title":@"我的消息",@"image":@"message"},
                          @{@"title":@"设置",@"image":@"set"},
                          ];
        
        [_dataSource addObject:arr];
        [_dataSource addObject:arr2];
        [_dataSource addObject:arr3];
        [_dataSource addObject:arr4];
        
    }
    return _dataSource;
}

@end
