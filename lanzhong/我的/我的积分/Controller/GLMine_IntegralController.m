//
//  GLMine_IntegralController.m
//  lanzhong
//
//  Created by 龚磊 on 2018/1/3.
//  Copyright © 2018年 三君科技有限公司. All rights reserved.
//

#import "GLMine_IntegralController.h"
#import "GLMine_IntegralCell.h"
#import "GLMine_IntegralModel.h"
#import "QQPopMenuView.h"

@interface GLMine_IntegralController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *models;
@property (nonatomic, strong)LoadWaitView *loadV;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NodataView *nodataV;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (nonatomic, strong)UIButton *fiterBtn;
@property (nonatomic, assign)NSInteger type;//筛选类型

@end

@implementation GLMine_IntegralController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    
    self.leftView.layer.cornerRadius = 5.f;
    self.rightView.layer.cornerRadius = 5.f;
    
    self.type = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"GLMine_IntegralCell" bundle:nil] forCellReuseIdentifier:@"GLMine_IntegralCell"];
    [self.tableView addSubview:self.nodataV];
    self.nodataV.hidden = YES;
    
//    __weak __typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
//        [weakSelf postRequest:YES];
        
    }];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
//        [weakSelf postRequest:NO];
        
    }];
    
    // 设置文字
    [header setTitle:@"快扯我，快点" forState:MJRefreshStateIdle];
    
    [header setTitle:@"数据要来啦" forState:MJRefreshStatePulling];
    
    [header setTitle:@"服务器正在狂奔..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    
    self.page = 1;
//    [self postRequest:YES];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

/**
 设置导航栏 title以及右键
 */
- (void)setNav{
    
    self.navigationItem.title = @"我的积分";
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//左对齐
    [button setImage:[UIImage imageNamed:@"downarr"] forState:UIControlStateNormal];
    [button setTitle:@"全部" forState:UIControlStateNormal];
    [button setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
    
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(fiter) forControlEvents:UIControlEventTouchUpInside];
    
    [button horizontalCenterTitleAndImage:5];
    
    self.fiterBtn = button;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.fiterBtn];
}

#pragma mark - 筛选

/**
 筛选
 */
-(void)fiter{
    
    NSArray *arr = @[@{@"title":@"全部",@"imageName":@""},
                     @{@"title":@"冻结积分",@"imageName":@""},
                     @{@"title":@"积分奖励",@"imageName":@""},
                     @{@"title":@"商品兑换",@"imageName":@""}];
    
    QQPopMenuView *popview = [[QQPopMenuView alloc] initWithItems:arr width:130 triangleLocation:CGPointMake([UIScreen mainScreen].bounds.size.width - 30, 64 + 5) action:^(NSInteger index) {
        
        [self.fiterBtn setTitle:arr[index][@"title"] forState:UIControlStateNormal];
        [self.fiterBtn horizontalCenterTitleAndImage:5];
        
        self.hidesBottomBarWhenPushed = YES;
        
        self.type = index;
        
        NSLog(@"-------%ld",index);
        switch (index) {
            case 0:
            {
//                GLMine_Wallet_ExchangeController *exchangeVC = [[GLMine_Wallet_ExchangeController alloc] init];
//                [self.navigationController pushViewController:exchangeVC animated:YES];
            }
                break;
            case 1:
            {
//                GLMine_Wallet_RechargeController*rechargeVC = [[GLMine_Wallet_RechargeController alloc] init];
//                [self.navigationController pushViewController:rechargeVC animated:YES];
            }
                break;
            default:
                break;
        }
    }];
    
    [popview show];
    
}

/**
 请求数据

 @param isRefresh 是否是下拉刷新
 */
- (void)postRequest:(BOOL)isRefresh{
    
    if (isRefresh) {
        self.page = 1;
    }else{
        self.page ++ ;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"token"] = [UserModel defaultUser].token;
    dic[@"uid"] = [UserModel defaultUser].uid;
    dic[@"state"] = @"1";//项目运行状态 1待审核(审核中) 2审核失败 3审核成功（审核成功认定为筹款中）4筹款停止 5筹款失败 6筹款完成 7项目进行 8项目暂停 9项目失败 10项目完成
    dic[@"page"] = @(self.page);
    
    _loadV = [LoadWaitView addloadview:[UIScreen mainScreen].bounds tagert:self.view];
    [NetworkManager requestPOSTWithURLStr:kMINE_MYPROJECT_URL paramDic:dic finish:^(id responseObject) {
        
        [_loadV removeloadview];
        [self endRefresh];
        
        if ([responseObject[@"code"] integerValue] == SUCCESS_CODE){
            if([responseObject[@"data"] count] != 0){
                
//                for (NSDictionary *dic in responseObject[@"data"]) {
//                    GLMine_IntegralModel * model = [GLMine_IntegralModel mj_objectWithKeyValues:dic];
//
//                    [self.models addObject:model];
//                }
            }
        }else if ([responseObject[@"code"] integerValue]==PAGE_ERROR_CODE){
            
            if (self.models.count != 0) {
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        }else{
           [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
        
        [self.tableView reloadData];
        
    } enError:^(NSError *error) {
        [_loadV removeloadview];
        [self endRefresh];
        [self.tableView reloadData];
    }];
}

- (void)endRefresh {
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.models.count== 0) {
        
        self.nodataV.hidden = NO;
    }else{
        self.nodataV.hidden = YES;
    }
    
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GLMine_IntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GLMine_IntegralCell"];
    
    GLMine_IntegralModel *model = self.models[indexPath.row];

    cell.model = model;

    cell.selectionStyle = 0;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

#pragma mark - 懒加载
- (NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
        for (int i = 0; i < 8; i ++) {
            GLMine_IntegralModel *model = [[GLMine_IntegralModel alloc] init];
            model.name = [NSString stringWithFormat:@"项目%d",i];
            model.detail = [NSString stringWithFormat:@"项目详情 很重要哦 %d",i];
            model.date = [NSString stringWithFormat:@"2017-09-0%d",i];
            model.integral = [NSString stringWithFormat:@"20%d",i];
            
            [_models addObject:model];
        }
    }
    return _models;
}
- (NodataView *)nodataV{
    if (!_nodataV) {
        _nodataV = [[NSBundle mainBundle] loadNibNamed:@"NodataView" owner:nil options:nil].lastObject;
        _nodataV.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
        
    }
    return _nodataV;
}


@end
